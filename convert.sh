#!/bin/bash

SRC_DIR="${1:-.}"
OUTPUT_DIR="${2:-converted}"

mkdir -p "$OUTPUT_DIR"

for file in "$SRC_DIR"/*.md; do
    [ -e "$file" ] || continue

    filename=$(basename "$file")
    echo "Converting: $filename"

    awk '
    BEGIN { in_frontmatter = 0; in_section = "" }

    /^\+\+\+\r?$/ {
        if (in_frontmatter) {
            in_frontmatter = 0
            print "---"
        } else {
            in_frontmatter = 1
            print "---"
        }
        next
    }

    in_frontmatter {
        if (/^\[taxonomies\]/) { in_section = "taxonomies"; next }
        if (/^\[extra\]/) { in_section = "extra"; next }
        if (/^[[:space:]]*\]$/) { in_section = ""; next }

        if (in_section == "taxonomies" && /^categories[[:space:]]*=/) {
            sub(/^categories[[:space:]]*=/, "category:")
            gsub(/\[|\]|"/g, "")
            print
            next
        }
        if (in_section == "taxonomies" && /^tags[[:space:]]*=/) {
            sub(/^tags[[:space:]]*=/, "tags:")
            gsub(/"/g, "")
            print
            next
        }

        if (in_section == "extra") { next }

        if (/^title[[:space:]]*=/) { sub(/^title[[:space:]]*=/, "title:"); print; next }
        if (/^description[[:space:]]*=/) { sub(/^description[[:space:]]*=/, "description:"); print; next }
        if (/^date[[:space:]]*=/) {
            for (i=1; i<=NF; i++) {
              if ($i == "=") {
                printf "date: %sT%s\n", $(i+1), $(i+2)
                break
              }
            }
            next
        }
        if (/^draft[[:space:]]*=/) { sub(/^draft[[:space:]]*=/, "draft:"); print; next }
    }

    !in_frontmatter { print }
    ' "$file" > "$OUTPUT_DIR/$filename"
done

echo "Done! Converted files in $OUTPUT_DIR/"
