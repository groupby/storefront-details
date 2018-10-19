#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}/.."

npm run docs
git commit -m "Generate docs" ./docs

release_type="$(sed -n '/## \[Unreleased\]/ s/.*\[\(.*\)\]/\1/p' CHANGELOG.md)"

npm version "$release_type"
