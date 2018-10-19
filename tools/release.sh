#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}/.."

npm run docs
git commit -m "Generate docs" ./docs
