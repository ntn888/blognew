#!/bin/sh

set -e

SRC_DIR="content/posts"
OUTPUT_DIR="public"
TEMPLATES_DIR="templates"
STATIC_DIR="static"
HEAD_EXTEND="templates/_head_extend.html"
INDEX_CONTENT="content/_index.md"

AUTHOR_NAME="Ajit Ananthadevan"
AUTHOR_SUBTITLE="Interested in Everything Embedded"
AUTHOR_IMAGE="/img/avatar.jpg"

SOCIAL_LINKS="https://github.com/ntn888 mastodon:@ajit_456@hachyderm.io mailto:ajit.ananthadevan@gmail.com /donate"

mkdir -p "$OUTPUT_DIR/posts"

if [ -d "$STATIC_DIR" ]; then
    cp -r "$STATIC_DIR"/. "$OUTPUT_DIR/"
    echo "Copied: $STATIC_DIR/* -> $OUTPUT_DIR/"
fi

if [ -f "$HEAD_EXTEND" ]; then
    HEAD_CONTENT=$(cat "$HEAD_EXTEND")
else
    HEAD_CONTENT=""
fi

parse_frontmatter() {
    input_file="$1"

    content=$(cat "$input_file")
    filename=$(basename "$input_file" .md)

    fm_title=""
    fm_date=""
    fm_category=""
    fm_description=""
    fm_tags=""
    fm_draft=""

    fm_lines=$(echo "$content" | awk '
        BEGIN { in_fm = 0 }
        /^---$/ { if (!in_fm) { in_fm = 1; next } else { in_fm = 0; exit } }
        in_fm { print }
    ')

    if [ -n "$fm_lines" ]; then
        fm_title=$(echo "$fm_lines" | awk -F': ' '/^title/ { sub(/^title: */, ""); gsub(/\r/, ""); gsub(/^"|"$/, ""); print }')
        fm_date=$(echo "$fm_lines" | awk -F': ' '/^date/ { sub(/^date: */, ""); gsub(/\r/, ""); gsub(/^"|"$/, ""); print }')
        fm_category=$(echo "$fm_lines" | awk -F': ' '/^category/ { sub(/^category: *\[? */, ""); gsub(/\r/, ""); gsub(/\]/, ""); gsub(/^"|"$/, ""); print }')
        fm_description=$(echo "$fm_lines" | awk -F': ' '/^description/ { sub(/^description: */, ""); gsub(/\r/, ""); gsub(/^"|"$/, ""); print }')
        fm_tags=$(echo "$fm_lines" | awk -F': ' '/^tags/ { sub(/^tags: *\[ */, ""); gsub(/\r/, ""); gsub(/\]/, ""); gsub(/, */, ","); print }' | sed 's/"//g' | sed 's/\r//g')
        fm_draft=$(echo "$fm_lines" | awk -F': ' '/^draft/ { sub(/^draft: */, ""); gsub(/\r/, ""); gsub(/^"|"$/, ""); print }')
    fi

    if [ "$fm_draft" = "true" ] || [ "$fm_draft" = "1" ]; then
        echo "DRAFT_SKIP"
        return
    fi

    if [ -n "$fm_title" ]; then
        html_title="$fm_title"
    else
        content_body=$(echo "$content" | awk '/^---$/ { found=1; next } found { print }')
        content_heading=$(echo "$content_body" | grep -m1 '^# ')
        if [ -n "$content_heading" ]; then
            html_title=$(echo "$content_heading" | sed 's/^# *//')
        else
            html_title=$(echo "$filename" | sed 's/-/ /g')
        fi
    fi

    echo "$filename|$html_title|$fm_date|$fm_category|$fm_description|$fm_tags"
}

format_date() {
    date_str="$1"
    if [ -z "$date_str" ]; then
        return
    fi

    if echo "$date_str" | grep -q 'T'; then
        date_part=$(echo "$date_str" | cut -d'T' -f1)
    else
        date_part="$date_str"
    fi

    month=$(echo "$date_part" | cut -d'-' -f2)
    day=$(echo "$date_part" | cut -d'-' -f3)
    year=$(echo "$date_part" | cut -d'-' -f1)

    case "$month" in
        01) month_name="Jan" ;;
        02) month_name="Feb" ;;
        03) month_name="Mar" ;;
        04) month_name="Apr" ;;
        05) month_name="May" ;;
        06) month_name="Jun" ;;
        07) month_name="Jul" ;;
        08) month_name="Aug" ;;
        09) month_name="Sep" ;;
        10) month_name="Oct" ;;
        11) month_name="Nov" ;;
        12) month_name="Dec" ;;
    esac

    echo "${month_name} ${day}, ${year}"
}

generate_archives() {
    archives_file="$OUTPUT_DIR/posts/index.html"
    mkdir -p "$OUTPUT_DIR/posts"

    sort -r /tmp/posts_data.txt > /tmp/posts_sorted.txt

    categories_html=""
    processed_categories=""
    while IFS='|' read -r _ _ _ post_category _; do
        [ -z "$post_category" ] && continue
        already_processed=0
        for processed_cat in $processed_categories; do
            [ "$processed_cat" = "$post_category" ] && already_processed=1 && break
        done
        [ "$already_processed" = "1" ] && continue

        processed_categories="${processed_categories}${post_category} "
        cat_posts=""
        while IFS='|' read -r pdate pslug ptitle pcat _; do
            [ -z "$pcat" ] && continue
            if [ "$pcat" = "$post_category" ]; then
                formatted_date=$(format_date "$pdate")
                cat_posts="${cat_posts}<li><a href=\"/posts/${pslug}/\">${ptitle}<span class=\"post-date\">${formatted_date}</span></a></li>"
            fi
        done < /tmp/posts_sorted.txt
        [ -n "$cat_posts" ] && categories_html="${categories_html}
        <section class=\"category-section\">
            <h2 class=\"category-title\">${post_category}</h2>
            <ul class=\"post-list\">${cat_posts}</ul>
        </section>"
    done < /tmp/posts_sorted.txt

    cat > "$archives_file" << ARCHIVESEOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Posts | Ajit Ananthadevan</title>
    <link rel="stylesheet" href="/main.css">
    <link rel="icon" type="image/png" sizes="32x32" href="/img/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/img/favicon-16x16.png">
    <link rel="apple-touch-icon" href="/img/apple-touch-icon.png">
ARCHIVESEOF

    if [ -n "$HEAD_CONTENT" ]; then
        printf '%s\n' "$HEAD_CONTENT" >> "$archives_file"
    fi

    cat >> "$archives_file" << ARCHIVESEOF
</head>
<body>
    <header>
        <nav><a href="/">home</a><span class="nav-separator">·</span><a href="/posts">posts</a><span class="nav-separator">·</span><a href="/services">services</a></nav>
    </header>
    <div class="wrapper">
        <header class="page-header">
            <h1>Posts</h1>
            <p>All posts grouped by category</p>
        </header>
        <section class="categories-section content-body">
            ${categories_html}
        </section>
    </div>
    <footer>
        <p>© Ajit</p>
    </footer>
</body>
</html>
ARCHIVESEOF

    echo "Generated: $archives_file"
}

generate_tag_pages() {
    mkdir -p "$OUTPUT_DIR/posts/tags"

    sort -r /tmp/posts_data.txt > /tmp/posts_sorted.txt

    while IFS='|' read -r fm_date filename html_title fm_category fm_tags; do
        clean_tags=$(echo "$fm_tags" | sed 's/" *, */,/g; s/"//g; s/^ *//; s/ *$//')
        echo "$clean_tags" | tr ',' '\n' >> /tmp/all_tags.txt
    done < /tmp/posts_sorted.txt

    sort -u /tmp/all_tags.txt > /tmp/unique_tags.txt

    while read tag; do
        tag=$(echo "$tag" | sed 's/^ *//;s/ *$//')
        [ -n "$tag" ] || continue

        tag_slug=$(echo "$tag" | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]')
        tag_dir="$OUTPUT_DIR/posts/tags/$tag_slug"
        mkdir -p "$tag_dir"

        posts_with_tag=""
        while IFS='|' read -r fm_date filename html_title fm_category fm_tags; do
            clean_post_tags=$(echo "$fm_tags" | sed 's/" *, */,/g; s/"//g; s/^ *//; s/ *$//')
            if echo ",${clean_post_tags}," | grep -q ",${tag},"; then
                formatted_date=$(format_date "$fm_date")
                posts_with_tag="${posts_with_tag}<li><a href=\"/posts/${filename}/\">${html_title}</a><span class=\"post-date\">${formatted_date}</span></li>"
            fi
        done < /tmp/posts_sorted.txt

        cat > "$tag_dir/index.html" << TAGEOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Posts tagged "${tag}" | Ajit Ananthadevan</title>
    <link rel="stylesheet" href="/main.css">
    <link rel="icon" type="image/png" sizes="32x32" href="/img/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/img/favicon-16x16.png">
    <link rel="apple-touch-icon" href="/img/apple-touch-icon.png">
</head>
<body>
    <header>
        <nav>
            <a href="/">home</a><span class="nav-separator">·</span><a href="/posts">posts</a><span class="nav-separator">·</span><a href="/services">services</a>
        </nav>
    </header>
    <div class="wrapper">
        <header class="page-header">
            <h1>Posts tagged "${tag}"</h1>
            <p><a href="/posts">← All posts</a></p>
        </header>
        <section class="content-body">
            <ul class="post-list">${posts_with_tag}</ul>
        </section>
    </div>
    <footer>
        <p>© Ajit</p>
    </footer>
</body>
</html>
TAGEOF
        echo "Generated: $tag_dir/index.html"
    done < /tmp/unique_tags.txt

    rm -f /tmp/all_tags.txt /tmp/unique_tags.txt /tmp/posts_sorted.txt /tmp/posts_data.txt
}

process_markdown() {
    input_file="$1"
    output_file="$2"

    slug="$3"
    html_title="$4"
    fm_date="$5"
    fm_category="$6"
    fm_description="$7"

    body=$(pandoc -f markdown -t html --syntax-highlighting=tango "$input_file")

    date_html=""
    if [ -n "$fm_date" ]; then
        formatted_date=$(format_date "$fm_date")
        date_only=$(echo "$fm_date" | cut -d'T' -f1)
        date_html="<time datetime=\"${date_only}\">${formatted_date}</time>"
    fi

    category_html=""
    if [ -n "$fm_category" ]; then
        category_html="<span class=\"post-category\">${fm_category}</span>"
    fi

    tags_html=""
    if [ -n "$fm_tags" ]; then
        clean_tags=$(echo "$fm_tags" | sed 's/" *, */,/g; s/"//g; s/^ *//; s/ *$//')
        echo "$clean_tags" | tr ',' '\n' > /tmp/tags_tmp.txt
        tags_html=$(while read tag; do
            tag=$(echo "$tag" | sed 's/^ *//;s/ *$//')
            [ -n "$tag" ] || continue
            tag_slug=$(echo "$tag" | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]')
            echo -n "<a class=\"post-tag\" href=\"/posts/tags/${tag_slug}\">${tag}</a>"
        done < /tmp/tags_tmp.txt)
        rm -f /tmp/tags_tmp.txt
    fi

    meta_html=""
    if [ -n "$date_html" ] || [ -n "$category_html" ] || [ -n "$tags_html" ]; then
        meta_html="<div class=\"post-meta\">${date_html}${category_html}${tags_html}</div>"
    fi

    description_html=""
    if [ -n "$fm_description" ]; then
        description_html="<meta name=\"description\" content=\"${fm_description}\">"
    fi

    cat > "$output_file" << HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${html_title} | Ajit Ananthadevan</title>
    ${description_html}
    <link rel="stylesheet" href="/main.css">
    <link rel="icon" type="image/png" sizes="32x32" href="/img/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/img/favicon-16x16.png">
    <link rel="apple-touch-icon" href="/img/apple-touch-icon.png">
${HEAD_CONTENT}
</head>
<body>
    <header>
        <nav>
            <a href="/">home</a><span class="nav-separator">·</span><a href="/posts">posts</a><span class="nav-separator">·</span><a href="/services">services</a>
        </nav>
    </header>
    <div class="wrapper">
        <article class="post content-body">
            <header class="post-header">
                <h1 class="post-title">${html_title}</h1>
                ${meta_html}
            </header>
            ${body}
        </article>
    </div>
    <footer>
        <p>© Ajit</p>
    </footer>
</body>
</html>
HTML
}

rm -f /tmp/posts_data.txt

    if [ -d "$SRC_DIR" ]; then
        for md_file in "$SRC_DIR"/*.md; do
            [ -e "$md_file" ] || continue

            result=$(parse_frontmatter "$md_file")

            if [ "$result" = "DRAFT_SKIP" ]; then
                echo "Skipping draft: $md_file"
                continue
            fi

            filename=$(echo "$result" | cut -d'|' -f1)
            html_title=$(echo "$result" | cut -d'|' -f2)
            fm_date=$(echo "$result" | cut -d'|' -f3)
            fm_category=$(echo "$result" | cut -d'|' -f4)
            fm_description=$(echo "$result" | cut -d'|' -f5)
            fm_tags=$(echo "$result" | cut -d'|' -f6)

            output_file="$OUTPUT_DIR/posts/${filename}/index.html"
            mkdir -p "$OUTPUT_DIR/posts/${filename}"
            process_markdown "$md_file" "$output_file" "$filename" "$html_title" "$fm_date" "$fm_category" "$fm_description"
            echo "Generated: $output_file"

            if [ -n "$fm_date" ]; then
                echo "${fm_date}|${filename}|${html_title}|${fm_category}|${fm_tags}" >> /tmp/posts_data.txt
            fi
        done
    fi

    if [ -f /tmp/posts_data.txt ] && [ -s /tmp/posts_data.txt ]; then
        generate_archives
        generate_tag_pages
    fi

if [ -f "$TEMPLATES_DIR/services.html" ]; then
    output_file="$OUTPUT_DIR/services/index.html"
    mkdir -p "$OUTPUT_DIR/services"

    if [ -n "$HEAD_CONTENT" ] && ! grep -q "$HEAD_CONTENT" "$TEMPLATES_DIR/services.html" 2>/dev/null; then
        awk '{print} /<\/head>/{print head_content "\n"}' head_content="$HEAD_CONTENT" "$TEMPLATES_DIR/services.html" > "$output_file"
    else
        cp "$TEMPLATES_DIR/services.html" "$output_file"
    fi
    echo "Generated: $output_file"
fi

if [ -f "$TEMPLATES_DIR/donate.html" ]; then
    output_file="$OUTPUT_DIR/donate/index.html"
    mkdir -p "$OUTPUT_DIR/donate"

    if [ -n "$HEAD_CONTENT" ] && ! grep -q "$HEAD_CONTENT" "$TEMPLATES_DIR/donate.html" 2>/dev/null; then
        awk '{print} /<\/head>/{print head_content "\n"}' head_content="$HEAD_CONTENT" "$TEMPLATES_DIR/donate.html" > "$output_file"
    else
        cp "$TEMPLATES_DIR/donate.html" "$output_file"
    fi
    echo "Generated: $output_file"
fi

if [ -f "$TEMPLATES_DIR/404.html" ]; then
    output_file="$OUTPUT_DIR/404.html"

    if [ -n "$HEAD_CONTENT" ] && ! grep -q "$HEAD_CONTENT" "$TEMPLATES_DIR/404.html" 2>/dev/null; then
        awk '{print} /<\/head>/{print head_content "\n"}' head_content="$HEAD_CONTENT" "$TEMPLATES_DIR/404.html" > "$output_file"
    else
        cp "$TEMPLATES_DIR/404.html" "$output_file"
    fi
    echo "Generated: $output_file"
fi

INDEX_BODY=""
if [ -f "$INDEX_CONTENT" ]; then
    INDEX_BODY=$(pandoc -f markdown -t html "$INDEX_CONTENT")
fi

github_icon=$(cat "$STATIC_DIR/icon/github.svg")
mastodon_icon=$(cat "$STATIC_DIR/icon/mastodon-fill.svg")
email_icon=$(cat "$STATIC_DIR/icon/email.svg")
donate_icon=$(cat "$STATIC_DIR/icon/hand-heart-fill.svg")

INDEX_HTML="$OUTPUT_DIR/index.html"
cat > "$INDEX_HTML" << INDEXEOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${AUTHOR_NAME}</title>
    <link rel="stylesheet" href="/main.css">
    <link rel="icon" type="image/png" sizes="32x32" href="/img/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/img/favicon-16x16.png">
    <link rel="apple-touch-icon" href="/img/apple-touch-icon.png">
INDEXEOF

if [ -n "$HEAD_CONTENT" ]; then
    printf '%s\n' "$HEAD_CONTENT" >> "$INDEX_HTML"
fi

cat >> "$INDEX_HTML" << INDEXEOF
</head>
<body>
    <header>
        <nav>
            <a href="/">home</a><span class="nav-separator">·</span><a href="/posts">posts</a><span class="nav-separator">·</span><a href="/services">services</a>
        </nav>
    </header>
    <div class="wrapper">
        <section class="author-header">
            <img src="${AUTHOR_IMAGE}" alt="${AUTHOR_NAME}" class="author-image">
            <div class="author-content">
                <div class="author-info">
                    <h1 class="author-name">${AUTHOR_NAME}</h1>
                    <p class="author-subtitle">${AUTHOR_SUBTITLE}</p>
                </div>
                <div class="social-links">
                    <a href="https://github.com/ntn888" title="GitHub">${github_icon}</a>
                    <a href="mastodon:@ajit_456@hachyderm.io" title="Mastodon">${mastodon_icon}</a>
                    <a href="mailto:ajit.ananthadevan@gmail.com" title="Email">${email_icon}</a>
                    <a href="/donate" title="Donate">${donate_icon}</a>
                </div>
            </div>
        </section>
        <div class="page-content content-body">
            ${INDEX_BODY}
        </div>
    </div>
    <footer>
        <p class="footer-built">Built with <a href="https://pandoc.org/" target="_blank" rel="noopener">pandoc</a>, <a href="https://github.com/anomalyco/opencode" target="_blank" rel="noopener">opencode</a> and <a href="https://huggingface.co/MiniMaxAI" target="_blank" rel="noopener">MiniMax</a></p>
        <p>© Ajit</p>
    </footer>
</body>
</html>
INDEXEOF

echo "Generated: $OUTPUT_DIR/index.html"
echo "Done! Site built in $OUTPUT_DIR/"
