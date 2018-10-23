
set -eo pipefail

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

info() {
  echo "===>" "$@"
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

info "Generating docs..."
npm run docs
git commit -m "Generate docs" ${CI:+'-m' "[ci skip]"} ./docs

info "Determining the release type..."
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

info "Bumping version in package.json..."
new_version="$(npm version "$release_type" --no-git-tag-version)"
info "New version: ${new_version}"

info "Updating changelog..."
ed -s CHANGELOG.md <<EOF
H
/\[Unreleased\].*/ s//[${new_version#v}] - $(date +%F)/
w
q
EOF

info "Committing changes..."
git commit -m "Release version ${new_version}" ${CI:+'-m' "[ci skip]"} package.json CHANGELOG.md

info "Tagging commit..."
sed -n '/## \[/,//p' CHANGELOG.md | sed -e '$d' -e 's/^##* *//' -e $'1a\\\n\\\n' |
git tag -a "$new_version" -F -

info "Pushing..."
git push --no-verify origin HEAD "$new_version"

info "Done."
