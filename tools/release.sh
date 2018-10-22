#!/usr/bin/env bash

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

cd "${BASH_SOURCE%/*}/.."

npm run docs
git commit -m "Generate docs" ./docs

release_type="$(sed -n '/## \[Unreleased\]\s*\[\(.*\)\]/ s//\1/p' CHANGELOG.md)"
[[ -n "$release_type" ]] || die "Could not detect potential release."

npm version "$release_type" --no-git-tag-version

new_version="$(npm view . version)"
sed -i'' "$(printf 's/\[Unreleased\].*/[%s] - %s/' "$new_version" "$(date +%F)")" CHANGELOG.md

msg="Release version ${new_version}"
git commit -m "$msg" .
git tag -a "v${new_version}" -m "$msg"
