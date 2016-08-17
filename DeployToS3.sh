#!/bin/bash

# These are defined here, could be in travis environment vars
MIME_TYPE="application/x-gzip"
TARGET_PATTERN="*/cookbooks-*.tar.gz"

# this comes from the travis build
# TRAVIS_BRANCH="master" || "stable-chef-11.10"

# These should be travis environment vars
# S3_ACCESS_KEY= access key for travis user
# S3_BUCKET= bucket to deliver assets to
# S3_POLICY= hashed policy document 
# S3_SIGNATURE= hash of policy and s3 access secret

if [ "$TRAVIS_BRANCH" == "master" ] || [ "$TRAVIS_BRANCH" == "stable-chef-11.10" ]; then
	for FILE in `ls $TARGET_PATTERN`; do
		BASE=`basename $FILE`
		DIR=`dirname $FILE`
		echo "delivering $TRAVIS_BRANCH/$DIR..."
		curl \
			-F "key=$TRAVIS_BRANCH/$DIR.tar.gz" \
			-F "acl=private" \
			-F "AWSAccessKeyId=$S3_ACCESS_KEY" \
			-F "Policy=$S3_POLICY" \
			-F "Signature=$S3_SIGNATURE" \
			-F "Content-Type=$MIME_TYPE" \
			-F "file=@$FILE" \
			https://s3.amazonaws.com/$S3_BUCKET
		if [ $? -ne 0 ]; then
			# Curl Failed
			exit 1
		fi
	done
fi

exit 0
