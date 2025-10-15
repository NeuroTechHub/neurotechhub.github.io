#!/bin/bash

# Function to extract required fields from an archetype file
# Excludes fields marked with "# Optional"
get_required_fields_from_archetype() {
  local archetype_file=$1
  local fields=()
  
  # Extract frontmatter from archetype
  local frontmatter=$(sed -n '/^---$/,/^---$/p' "$archetype_file" | sed '1d;$d')
  
  # Find all field names, excluding those with "# Optional" comment
  while IFS= read -r line; do
    # Skip empty lines and comments
    if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
      continue
    fi
    
    # Check if line contains a field definition (field:)
    if [[ "$line" =~ ^[[:space:]]*([a-z_]+):[[:space:]]* ]]; then
      field="${BASH_REMATCH[1]}"
      
      # Check if line has "# Optional" comment
      if [[ ! "$line" =~ "#"[[:space:]]*[Oo]ptional ]]; then
        fields+=("$field")
      fi
    fi
  done <<< "$frontmatter"
  
  # Return fields as space-separated string
  echo "${fields[@]}"
}

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
echo "=== Testing Archetype Field Compliance ==="
errors=0

for file in $(find content -name "index.md" -type f); do
  # Skip _index.md files
  if [[ "$file" == *"_index.md" ]]; then
    continue
  fi

  # Extract frontmatter
  frontmatter=$(sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d')
  
  # Determine content type and archetype file
  if [[ "$file" == *"content/blog/posts/"* ]]; then
    content_type="blog"
    archetype_file="archetypes/blog.md"
    expected_type="blog"
  elif [[ "$file" == *"content/talks/events/"* ]]; then
    content_type="talk"
    archetype_file="archetypes/talks.md"
    expected_type="talk"
  else
    # Skip files not in blog/posts or talks/events
    continue
  fi

  # Check if archetype file exists
  if [ ! -f "$archetype_file" ]; then
    echo "❌ Archetype file not found: $archetype_file"
    errors=$((errors + 1))
    continue
  fi

  # Get required fields from archetype (excluding Optional fields)
  required_fields=($(get_required_fields_from_archetype "$archetype_file"))

  # Check each required field exists exactly once
  for field in "${required_fields[@]}"; do
    count=$(echo "$frontmatter" | grep -c "^${field}:")
    
    if [ $count -eq 0 ]; then
      echo "❌ Missing required field '$field' in $file"
      echo "   Content type: $content_type (based on archetype: $archetype_file)"
      errors=$((errors + 1))
    elif [ $count -gt 1 ]; then
      echo "❌ Duplicate field '$field' (found $count times) in $file"
      echo "   Content type: $content_type"
      errors=$((errors + 1))
    fi
  done

done

if [ $errors -gt 0 ]; then
  echo ""
  echo "❌ Found $errors archetype compliance error(s)"
  echo "Ensure all required fields from the archetype are present exactly once."
  echo "Fields marked with '# Optional' in the archetype are not required."
  echo "Run 'hugo new blog/posts/my-post' or 'hugo new talks/events/my-event' to generate properly structured content."
  exit 1
else
  echo "✓ All files comply with archetype requirements!"
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
    # Check if file exists (case-insensitive on macOS, but we need exact match)
    if [ ! -f "$md_dir/$featured_image" ]; then
      echo "❌ Missing featured_image in $md_file: $featured_image"
      echo "   Expected location: $md_dir/$featured_image"
      errors=$((errors + 1))
    else
      # Check for exact filename match (case-sensitive)
      actual_file=$(ls "$md_dir" | grep -x "$featured_image" || true)
      if [ -z "$actual_file" ]; then
        echo "❌ Case mismatch for featured_image in $md_file: $featured_image"
        echo "   File exists but with different case. Check the exact filename."
        errors=$((errors + 1))
      fi
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
    else
      # Check for exact filename match (case-sensitive)
      actual_file=$(ls "$md_dir" | grep -x "$image" || true)
      if [ -z "$actual_file" ]; then
        echo "❌ Case mismatch for markdown image in $md_file: $image"
        echo "   File exists but with different case. Check the exact filename."
        errors=$((errors + 1))
      fi
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
    else
      # Check for exact filename match (case-sensitive)
      actual_file=$(ls "$md_dir" | grep -x "$image" || true)
      if [ -z "$actual_file" ]; then
        echo "❌ Case mismatch for HTML image in $md_file: $image"
        echo "   File exists but with different case. Check the exact filename."
        errors=$((errors + 1))
      fi
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