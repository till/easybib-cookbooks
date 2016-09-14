#!/bin/bash

set -e
shopt -s nullglob

TARGET_PATTERN="*/cookbooks-*.tar.gz"

if [[ ! -r ./MoveBerkshelfArtifacts.sh ]]; then
    echo "Please make sure you are in the cookbook root directory!"
    exit 1
fi

mkdir -p build

for FILE in ${TARGET_PATTERN}; do
    BASE=$(basename $FILE)
    DIR=$(dirname $FILE)
    printf "%-50s => %s\n" "$FILE"  "build/artifact-${DIR}.tar.gz'"
    mv "$FILE" "build/artifact-${DIR}.tar.gz"
done
