#!/usr/bin/env bash

set -eo pipefail

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

cd "${BASH_SOURCE%/*}/.."

# Generate docs
npm run docs
git commit -m "Generate docs" ./docs

# Determine release type
release_type="$(sed -n '/## \[Unreleased\] \[\(.*\)\]/ s//\1/p' CHANGELOG.md)"
case "$release_type" in
  major | minor | patch | premajor | preminor | prepatch | prerelease | from-git)
    : # valid; do nothing
    ;;
  '')
    die "Could not detect potential release in the CHANGELOG."
    ;;
  *)
    die "Unsupported release type: ${release_type}"
    ;;
esac

# Bump package.json
new_version="$(npm version "$release_type" --no-git-tag-version)"

# Bump CHANGELOG
ed CHANGELOG.md <<EOF
/\[Unreleased\].*/ s//[${new_version#v}] - $(date +%F)/
w
q
EOF

# Commit changes
msg="Release version ${new_version}"
git commit -m "$msg" package.json CHANGELOG.md

# Tag with version
sed -n '/## \[/,//p' CHANGELOG.md | sed -e '$d' -e 's/^##* *//' -e $'1a\\\n\\\n' |
git tag -a "$new_version" -F -

# Push
git push origin HEAD "$new_version"
