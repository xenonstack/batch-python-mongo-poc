#!/bin/bash

# Fail on all script errors
set -e
[ "${DEBUG:-false}" == 'true' ] && { set -x; S3FS_DEBUG='-d -d'; }


: ${AWS_S3_AUTHFILE:='/root/.s3fs'}
: ${AWS_S3_MOUNTPOINT:='/mnt'}
: ${AWS_S3_URL:='https://s3.amazonaws.com'}
: ${S3FS_ARGS:=''}

aws s3 ls s3://$AWS_STORAGE_BUCKET_NAME/

aws s3 sync s3://$AWS_STORAGE_BUCKET_NAME/ /data/db


mongod --fork --logpath /var/log/mongodb.log

python3 -u /usr/src/app/read_increment_counter.py

/usr/bin/mongod  --shutdown

aws s3 sync /data/db s3://$AWS_STORAGE_BUCKET_NAME/
