#!/bin/sh

export PATH=/bin:/usr/bin:/usr/local/bin

SQLHOST="$1"
SQLUSER="$2"
SQLPASS="$3"
S3BUCKET="$4"
S3ACCESSKEYID="$5"
S3SECRETACCESSKEY="$6"
PREFIX="$7"
BACKUPFILE="${PREFIX}-`date '+%Y%m%d%H%M'`.sql"

cd /tmp
logger -t rdsbackup "Started running mysqldump for $SQLHOST"
mysqldump -h "$SQLHOST" -u "$SQLUSER" -p"$SQLPASS" --all-databases > $BACKUPFILE
logger -t rdsbackup "Finished running mysqldump for $SQLHOST"
bzip2 --best $BACKUPFILE
logger -t rdsbackup "Finished bzipping file for $SQLHOST"
/usr/local/bin/s3uploadfix.sh --bucket "$S3BUCKET" --accesskeyid "$S3ACCESSKEYID" --secretaccesskey "$S3SECRETACCESSKEY" ${BACKUPFILE}.bz2
logger -t rdsbackup "Finished uploading dump from $SQLHOST to $S3BUCKET"
rm -f ${BACKUPFILE}.bz2
