#!/usr/bin/env bash

set -eo pipefail

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

print_usage() {
  cat <<EOF
Usage: ${0##*/}
       ${0##*/} -h
Creates a release.

This performs the following steps:
1. Generates the documentation
2. Bumps the version number in package.json
3. Finalizes the release in CHANGELOG.md
4. Creates a git tag
EOF
}

cd "${BASH_SOURCE%/*}/.."

while getopts "h" opt; do
  case "$opt" in
    h)
      print_usage
      exit 0
      ;;
  esac
done

# Generate docs
npm run docs
git commit -m "Generate docs" ${CI:+'-m' "[ci skip]"} ./docs

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
ed -s CHANGELOG.md <<EOF
H
/\[Unreleased\].*/ s//[${new_version#v}] - $(date +%F)/
w
q
EOF

# Commit changes
git commit -m "Release version ${new_version}" ${CI:+'-m' "[ci skip]"} package.json CHANGELOG.md

# Tag with version, annotate with changelog entry
sed -n '/## \[/,//p' CHANGELOG.md | sed -e '$d' -e 's/^##* *//' -e $'1a\\\n\\\n' |
git tag -a "$new_version" -F -

# Push
git push --no-verify origin HEAD "$new_version"
