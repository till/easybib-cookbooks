#!/usr/bin/env python

import boto, argparse, sys, os

parser = argparse.ArgumentParser(description='Upload a file to Amazon S3, into the specified bucket.')
parser.add_argument('--bucket', help='the name of the bucket')
parser.add_argument('--accesskeyid', help='AWS access key id')
parser.add_argument('--secretaccesskey', help='AWS secret access key')
parser.add_argument('files', type=file, metavar='F', nargs='+', help='file to upload');

args = parser.parse_args()

if not args.bucket:
    print "Please supply a bucket name."
    sys.exit(1)

if not args.files:
    print "Please supply a file (or a list of files) to upload."
    sys.exit(1)

if not args.accesskeyid:
    print "Please supply an AWS access key id."
    sys.exit(1)

if not args.secretaccesskey:
    print "Please supply an AWS secret access key."
    sys.exit(1)

bucket_name = args.bucket
access_key_id = args.accesskeyid
secret_access_key = args.secretaccesskey

def percent_cb(complete, total):
    sys.stdout.write('.')
    sys.stdout.flush()

from boto.s3.key import Key
conn = boto.connect_s3(access_key_id, secret_access_key)

bucket = conn.get_bucket(bucket_name)

k = Key(bucket)

for f in args.files:

    print 'Uploading %s to Amazon S3 bucket %s' % \
        (f.name, bucket_name)

    k.key = os.path.basename(f.name)

    k.set_contents_from_filename(f.name, cb=percent_cb, num_cb=10)


print ""
sys.exit(0)
