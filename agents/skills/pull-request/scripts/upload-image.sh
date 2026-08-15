#!/usr/bin/env bash
# Upload an image to GitHub's user-attachments store and print the URL to embed.
#
# Usage: upload-image.sh <file> <owner/repo>
#
# The endpoint is undocumented and requires write access to the named repo.
# A non-201 means fall back to the orphan-branch mechanism in reference/images.md,
# not that the image is unusable.

set -euo pipefail

file=${1-}
repo=${2-}

if [[ -z $file || -z $repo ]]; then
  echo "usage: upload-image.sh <file> <owner/repo>" >&2
  exit 2
fi

if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 2
fi

case ${file##*.} in
  png) content_type=image/png ;;
  jpg | jpeg) content_type=image/jpeg ;;
  gif) content_type=image/gif ;;
  webp) content_type=image/webp ;;
  svg) content_type=image/svg+xml ;;
  mp4) content_type=video/mp4 ;;
  mov) content_type=video/quicktime ;;
  webm) content_type=video/webm ;;
  *)
    echo "unsupported extension: ${file##*.} — GitHub enforces a MIME allowlist and the extension must match" >&2
    exit 2
    ;;
esac

if ! repo_id=$(gh api "repos/$repo" --jq .id 2>/dev/null); then
  echo "cannot resolve repo $repo — check the owner/repo spelling and that you can see it" >&2
  exit 2
fi

name=$(basename "$file")

# Percent-encode both query values. `image/svg+xml` is the case that bites:
# a raw `+` reaches the server as a space and the upload 422s.
urlencode() { jq -rn --arg s "$1" '$s|@uri'; }
name_param=$(urlencode "$name")
content_type_param=$(urlencode "$content_type")

response=$(mktemp)
trap 'rm -f "$response"' EXIT

status=$(curl -sS -o "$response" -w '%{http_code}' \
  -X POST "https://uploads.github.com/user-attachments/assets?name=${name_param}&content_type=${content_type_param}&repository_id=${repo_id}" \
  -H "Authorization: Bearer $(gh auth token)" \
  -H "Accept: application/json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  --data-binary "@$file")

if [[ $status != 201 ]]; then
  echo "upload failed with HTTP $status" >&2
  cat "$response" >&2
  echo >&2
  echo "Fall back to the orphan-branch mechanism in reference/images.md." >&2
  exit 1
fi

url=$(jq -r .url <"$response")

echo "$url"

case $content_type in
  video/*)
    echo >&2
    echo "Video: post this URL bare on its own line. Wrapping it in ![]() breaks the inline player." >&2
    ;;
esac
