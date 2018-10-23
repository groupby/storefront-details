#!/usr/bin/env bash

set -eo pipefail

tag=latest

die() {
  echo "ERROR:" "$@" >&2
  exit 1
}

cd "${BASH_SOURCE%/*}/.."

while getopts ":t:" opt; do
  case $opt in
    t)
      tag=$OPTARG
      ;;
    \?)
      die "Invalid option: -$OPTARG" 
      ;;
  esac
done

npm publish --tag "$tag"
