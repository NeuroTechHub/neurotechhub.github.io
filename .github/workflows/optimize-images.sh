#!/bin/bash

echo "=== Image Optimization Script ==="
echo "This will resize/compress images over 500KB"
echo ""

MAX_SIZE=512000  # 500 KB in bytes

# Optimization passes (increasingly aggressive)
PASS1_WIDTH=2000
PASS1_QUALITY=85

PASS2_WIDTH=2000
PASS2_QUALITY=75

PASS3_WIDTH=1800
PASS3_QUALITY=65

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
    echo "❌ ImageMagick is not installed!"
    echo ""
    echo "Install it first:"
    echo "  macOS:   brew install imagemagick"
    echo "  Ubuntu:  sudo apt-get install imagemagick"
    echo "  Fedora:  sudo dnf install imagemagick"
    exit 1
fi

# Use 'magick convert' on newer ImageMagick, 'convert' on older
if command -v magick &> /dev/null; then
    CONVERT_CMD="magick convert"
else
    CONVERT_CMD="convert"
fi

optimized_count=0
skipped_count=0

echo "Scanning for images..."
echo ""

# Find all markdown files in page bundles (index.md files)
for md_file in $(find content -name "index.md" -type f); do
  md_dir=$(dirname "$md_file")

  # Check all image files in the directory
  for file in "$md_dir"/*; do
    filename=$(basename "$file")

    # Skip index.md and directories
    if [ "$filename" == "index.md" ] || [ -d "$file" ]; then
      continue
    fi

    # Check if file is an image (skip SVG as it's vector)
    if [[ "$filename" =~ \.(jpg|jpeg|JPG|JPEG|png|PNG|gif|GIF|webp|WEBP)$ ]]; then
      # Get file size in bytes
      if [[ "$OSTYPE" == "darwin"* ]]; then
        file_size=$(stat -f%z "$file")
      else
        file_size=$(stat -c%s "$file")
      fi

      if [ $file_size -gt $MAX_SIZE ]; then
        # Convert to MB for display
        size_mb=$(echo "scale=2; $file_size / 1048576" | bc)

        echo "📸 Optimizing: $filename (${size_mb}MB)"

        # Create backup
        cp "$file" "$file.backup"

        # Try multiple optimization passes
        optimized=false

        # Pass 1: Gentle optimization
        echo "   Pass 1: ${PASS1_WIDTH}px width, quality ${PASS1_QUALITY}..."
        if [[ "$filename" =~ \.(jpg|jpeg|JPG|JPEG)$ ]]; then
          $CONVERT_CMD "$file.backup" -resize "${PASS1_WIDTH}x${PASS1_WIDTH}>" -quality $PASS1_QUALITY "$file.tmp" 2>/dev/null
        elif [[ "$filename" =~ \.(png|PNG)$ ]]; then
          $CONVERT_CMD "$file.backup" -resize "${PASS1_WIDTH}x${PASS1_WIDTH}>" -strip "$file.tmp" 2>/dev/null
        else
          $CONVERT_CMD "$file.backup" -resize "${PASS1_WIDTH}x${PASS1_WIDTH}>" "$file.tmp" 2>/dev/null
        fi

        if [ -f "$file.tmp" ]; then
          if [[ "$OSTYPE" == "darwin"* ]]; then
            new_size=$(stat -f%z "$file.tmp")
          else
            new_size=$(stat -c%s "$file.tmp")
          fi

          if [ $new_size -le $MAX_SIZE ]; then
            optimized=true
            mv "$file.tmp" "$file"
          fi
        fi

        # Pass 2: More aggressive if still too large
        if [ "$optimized" = false ] && [ -f "$file.backup" ]; then
          echo "   Pass 2: ${PASS2_WIDTH}px width, quality ${PASS2_QUALITY}..."
          rm -f "$file.tmp"

          if [[ "$filename" =~ \.(jpg|jpeg|JPG|JPEG)$ ]]; then
            $CONVERT_CMD "$file.backup" -resize "${PASS2_WIDTH}x${PASS2_WIDTH}>" -quality $PASS2_QUALITY "$file.tmp" 2>/dev/null
          elif [[ "$filename" =~ \.(png|PNG)$ ]]; then
            $CONVERT_CMD "$file.backup" -resize "${PASS2_WIDTH}x${PASS2_WIDTH}>" -strip -colors 256 "$file.tmp" 2>/dev/null
          else
            $CONVERT_CMD "$file.backup" -resize "${PASS2_WIDTH}x${PASS2_WIDTH}>" "$file.tmp" 2>/dev/null
          fi

          if [ -f "$file.tmp" ]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
              new_size=$(stat -f%z "$file.tmp")
            else
              new_size=$(stat -c%s "$file.tmp")
            fi

            if [ $new_size -le $MAX_SIZE ]; then
              optimized=true
              mv "$file.tmp" "$file"
            fi
          fi
        fi

        # Pass 3: Very aggressive if still too large
        if [ "$optimized" = false ] && [ -f "$file.backup" ]; then
          echo "   Pass 3: ${PASS3_WIDTH}px width, quality ${PASS3_QUALITY}..."
          rm -f "$file.tmp"

          if [[ "$filename" =~ \.(jpg|jpeg|JPG|JPEG)$ ]]; then
            $CONVERT_CMD "$file.backup" -resize "${PASS3_WIDTH}x${PASS3_WIDTH}>" -quality $PASS3_QUALITY "$file.tmp" 2>/dev/null
          elif [[ "$filename" =~ \.(png|PNG)$ ]]; then
            $CONVERT_CMD "$file.backup" -resize "${PASS3_WIDTH}x${PASS3_WIDTH}>" -strip -colors 128 "$file.tmp" 2>/dev/null
          else
            $CONVERT_CMD "$file.backup" -resize "${PASS3_WIDTH}x${PASS3_WIDTH}>" "$file.tmp" 2>/dev/null
          fi

          if [ -f "$file.tmp" ]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
              new_size=$(stat -f%z "$file.tmp")
            else
              new_size=$(stat -c%s "$file.tmp")
            fi

            if [ $new_size -le $MAX_SIZE ]; then
              optimized=true
              mv "$file.tmp" "$file"
            else
              # Even aggressive optimization didn't work
              mv "$file.tmp" "$file"
              optimized=false
            fi
          fi
        fi

        # Report results
        if [ "$optimized" = true ] || [ -f "$file" ]; then
          if [[ "$OSTYPE" == "darwin"* ]]; then
            final_size=$(stat -f%z "$file")
          else
            final_size=$(stat -c%s "$file")
          fi

          new_size_kb=$(echo "scale=0; $final_size / 1024" | bc)
          reduction=$(echo "scale=1; 100 - ($final_size * 100 / $file_size)" | bc)

          if [ $final_size -le $MAX_SIZE ]; then
            echo "   ✅ Reduced to ${new_size_kb}KB (${reduction}% smaller)"
          else
            echo "   ⚠️  Reduced to ${new_size_kb}KB (${reduction}% smaller) - still over 500KB"
            echo "      Consider manually optimizing or choosing a different image"
          fi

          optimized_count=$((optimized_count + 1))
        else
          echo "   ❌ Optimization failed, keeping original"
          mv "$file.backup" "$file"
        fi

        # Cleanup
        rm -f "$file.backup" "$file.tmp"

        echo ""
      else
        skipped_count=$((skipped_count + 1))
      fi
    fi
  done
done

echo "================================"
echo "✨ Optimization complete!"
echo "   Optimized: $optimized_count images"
echo "   Skipped: $skipped_count images (already under 500KB)"
echo ""
echo "Run validation to check results:"
echo "   .github/workflows/validate-content.sh"
