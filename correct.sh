#!/bin/bash

SRC_DIR="${1:-.}"

for file in "$SRC_DIR"/*.md; do
    [ -e "$file" ] || continue
    awk '{
        gsub(/\]\(@/, "](")
        gsub(/\.md\)/, ")")
        print
    }' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    echo "Corrected: $file"
done
