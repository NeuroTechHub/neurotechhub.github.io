#!/bin/bash

echo "=== Testing Frontmatter Validation ==="
errors=0
for file in $(find content -name "*.md"); do
  # Skip _index.md files (list pages don't need date fields)
  if [[ "$file" == *"_index.md" ]]; then
    continue
  fi

  # Check if file has frontmatter
  if ! grep -q "^---$" "$file"; then
    echo "Missing frontmatter in: $file, please read instructions on how to create a post."
    errors=$((errors + 1))
    continue
  fi

  # Extract frontmatter and check required fields
  frontmatter=$(sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d')

  # Check for title
  if ! echo "$frontmatter" | grep -q "^title:"; then
    echo "Missing title in: $file"
    errors=$((errors + 1))
  fi

  # Check date field based on content type
  if [[ "$file" == *"content/blog/"* ]]; then
    # Blog posts need date: field
    if ! echo "$frontmatter" | grep -q "^date:"; then
      echo "Missing date: field in blog post: $file"
      errors=$((errors + 1))
    fi
  elif [[ "$file" == *"content/talks/"* ]]; then
    # Talks/events need event_date: field
    if ! echo "$frontmatter" | grep -q "^event_date:"; then
      echo "Missing event_date: field in talk/event: $file"
      errors=$((errors + 1))
    fi
  fi
done

if [ $errors -gt 0 ]; then
  echo "❌ Found $errors frontmatter errors"
  exit 1
else
  echo "✓ All frontmatter valid!"
fi

echo ""
echo "=== Testing Image References ==="
errors=0

# Find all markdown files in page bundles (index.md files)
for md_file in $(find content -name "index.md" -type f); do
  md_dir=$(dirname "$md_file")

  # Check featured_image from frontmatter
  featured_image=$(grep 'featured_image:' "$md_file" | sed 's/.*featured_image: *"\([^"]*\)".*/\1/' | grep -v '^featured_image:' || true)

  if [ ! -z "$featured_image" ]; then
    if [ ! -f "$md_dir/$featured_image" ]; then
      echo "❌ Missing featured_image in $md_file: $featured_image"
      echo "   Expected location: $md_dir/$featured_image"
      errors=$((errors + 1))
    fi
  fi

  # Check markdown image references: ![alt](image.jpg)
  grep -o '!\[[^]]*\]([^)]*)' "$md_file" | sed 's/.*(\([^)]*\)).*/\1/' | while read -r image; do
    # Skip empty lines, absolute URLs (http, https, /)
    if [ -z "$image" ] || [[ "$image" == http* ]] || [[ "$image" == /* ]]; then
      continue
    fi

    if [ ! -f "$md_dir/$image" ]; then
      echo "❌ Missing markdown image in $md_file: $image"
      echo "   Expected location: $md_dir/$image"
      errors=$((errors + 1))
    fi
  done

  # Check HTML image references: <img src="image.jpg">
  grep -o '<img[^>]*src="[^"]*"' "$md_file" | sed 's/.*src="\([^"]*\)".*/\1/' | while read -r image; do
    # Skip empty lines, absolute URLs (http, https, /)
    if [ -z "$image" ] || [[ "$image" == http* ]] || [[ "$image" == /* ]]; then
      continue
    fi

    if [ ! -f "$md_dir/$image" ]; then
      echo "❌ Missing HTML image in $md_file: $image"
      echo "   Expected location: $md_dir/$image"
      errors=$((errors + 1))
    fi
  done
done

if [ $errors -gt 0 ]; then
  echo ""
  echo "❌ Found $errors missing image(s)"
  echo "All images must be placed in the same folder as the markdown file (page bundle)"
  exit 1
else
  echo "✓ All referenced images found!"
fi

echo ""
echo "=== Testing for Unused Files ==="
warnings=0

# Find all markdown files in page bundles (index.md files)
for md_file in $(find content -name "index.md" -type f); do
  md_dir=$(dirname "$md_file")

  # Get all files in the directory except index.md
  for file in "$md_dir"/*; do
    filename=$(basename "$file")

    # Skip the index.md file itself
    if [ "$filename" == "index.md" ]; then
      continue
    fi

    # Skip directories
    if [ -d "$file" ]; then
      continue
    fi

    # Check if the file is referenced in index.md (case-insensitive)
    if ! grep -qi "$filename" "$md_file"; then
      echo "⚠️  Unused file in $md_dir: $filename"
      warnings=$((warnings + 1))
    fi
  done
done

if [ $warnings -gt 0 ]; then
  echo ""
  echo "⚠️  Found $warnings unused file(s)"
  echo "Consider removing unused files or referencing them in the markdown"
  # Don't exit with error for warnings, just inform
else
  echo "✓ No unused files found!"
fi

echo ""
echo "=== Testing Image File Sizes ==="
errors=0
MAX_SIZE=512000  # 500 KB in bytes

# Find all markdown files in page bundles (index.md files)
for md_file in $(find content -name "index.md" -type f); do
  md_dir=$(dirname "$md_file")

  # Check all image files in the directory
  for file in "$md_dir"/*; do
    filename=$(basename "$file")

    # Skip index.md
    if [ "$filename" == "index.md" ]; then
      continue
    fi

    # Skip directories
    if [ -d "$file" ]; then
      continue
    fi

    # Check if file is an image (by extension)
    if [[ "$filename" =~ \.(jpg|jpeg|JPG|JPEG|png|PNG|gif|GIF|webp|WEBP|svg|SVG)$ ]]; then
      # Get file size in bytes
      if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        file_size=$(stat -f%z "$file")
      else
        # Linux
        file_size=$(stat -c%s "$file")
      fi

      if [ $file_size -gt $MAX_SIZE ]; then
        # Convert to KB or MB for display
        if [ $file_size -gt 1048576 ]; then
          size_display=$(echo "scale=2; $file_size / 1048576" | bc)"MB"
        else
          size_display=$(echo "scale=0; $file_size / 1024" | bc)"KB"
        fi

        echo "❌ Image too large in $md_dir: $filename ($size_display)"
        echo "   Maximum allowed: 500KB"
        errors=$((errors + 1))
      fi
    fi
  done
done

if [ $errors -gt 0 ]; then
  echo ""
  echo "❌ Found $errors image(s) exceeding size limit"
  echo "Please optimize images before committing:"
  echo "  - Use tools like ImageOptim, TinyPNG, or squoosh.app"
  echo "  - Resize large images to reasonable dimensions"
  echo "  - Convert to WebP format for better compression"
  exit 1
else
  echo "✓ All images are within size limits!"
fi
