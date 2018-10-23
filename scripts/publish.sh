#!/usr/bin/env bash

set -eo pipefail

tag=latest

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

cd "${BASH_SOURCE%/*}/.."

while getopts ":t:" opt; do
  case "$opt" in
    t)
      tag="$OPTARG"
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
