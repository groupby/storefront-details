#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}/.."

npm run docs
git commit -m "Generate docs" ./docs

release_type="$(sed -n '/## \[Unreleased\]/ s/.*\[\(.*\)\]/\1/p' CHANGELOG.md)"

npm version "$release_type" --no-git-tag-version
new_version="$(sed -n '/"version"/ s/.*"\(.*\)",\{0,1\}/\1/p' package.json)"
sed -i '' "s/\[Unreleased\][^$]*/[$new_version] - `date +%Y-%m-%d`/" CHANGELOG.md

msg="Release version $new_version"
git commit -m "$msg" .
git tag -a "v$new_version" -m "$msg"
