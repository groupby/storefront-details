#!/usr/bin/env bash

set -eo pipefail

tag=latest

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

print_usage() {
  cat <<EOF
Usage: ${0##*/} [OPTIONS]
       ${0##*/} -h
Publishes the current package to npm.

OPTIONS
EOF
  sed -n '/^[[:space:]]*###/ s//   /p' "$BASH_SOURCE"
}

cd "${BASH_SOURCE%/*}/.."

while getopts ":t:h" opt; do
  case "$opt" in
    ### -t	The npm tag to release to (defaults to "latest").
    t)
      tag="$OPTARG"
      ;;
    ### -h	Print this help.
    h)
      print_usage
      exit 0
      ;;
    \?)
      die "Invalid option: -${OPTARG}"
      ;;
  esac
done

shift $((OPTIND - 1))

npm publish --tag "$tag"

version="$(node -p "require('./package.json').version")"

tries_left=30

until npm view ".@${version}" | grep -q .; do
  ((--tries_left)) || die "Published version validation timed out."
  echo "Version ${version} not yet on npm. Waiting 10 seconds..."
  sleep 10
done
