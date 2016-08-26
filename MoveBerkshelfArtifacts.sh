#!/bin/bash

TARGET_PATTERN="*/cookbooks-*.tar.gz"

for FILE in `ls */cookbooks-*.tar.gz`; do
	BASE=`basename $FILE`
	DIR=`dirname $FILE`
	mv $FILE build/artifact-$DIR.tar.gz
done

exit 0

