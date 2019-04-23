#!/bin/bash

# Fail on all script errors
set -e
[ "${DEBUG:-false}" == 'true' ] && { set -x; S3FS_DEBUG='-d -d'; }


: ${AWS_S3_AUTHFILE:='/root/.s3fs'}
: ${AWS_S3_MOUNTPOINT:='/mnt'}
: ${AWS_S3_URL:='https://s3.amazonaws.com'}
: ${S3FS_ARGS:=''}

mkdir /mnt/db_ram_disk

mount -t tmpfs -o size=1024m db_ram_disk /mnt/db_ram_disk


aws s3 sync s3://$AWS_STORAGE_BUCKET_NAME/ /mnt/db_ram_disk


mongod --fork --logpath /var/log/mongodb.log --dbpath /mnt/db_ram_disk

python3 -u /usr/src/app/read_increment_counter.py

/usr/bin/mongod  --shutdown

aws s3 sync /mnt/db_ram_disk s3://$AWS_STORAGE_BUCKET_NAME/
