#!/usr/bin/env bash

set -eo pipefail

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

cd "${BASH_SOURCE%/*}/.."

npm run docs
git commit -m "Generate docs" ./docs

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

new_version="$(npm version "$release_type" --no-git-tag-version)"

ed CHANGELOG.md <<EOF
/\[Unreleased\].*/ s//[${new_version}] - $(date +%F)/
w
q
EOF

msg="Release version ${new_version}"
git commit -m "$msg" package.json CHANGELOG.md
tag_name="v${new_version}"
sed -n '/## \[/,//'p CHANGELOG.md | sed -e '$d' -e 's/^##* *//' -e $'1a\\\n\\\n' |
git tag -a "$tag_name" -F -
git push origin HEAD "$tag_name"
