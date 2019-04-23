FROM       ubuntu:16.04
MAINTAINER Gursimran Singh

ENV VERSION 1.83

# Installation:
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev apt-transport-https \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip


################## BEGIN MONGO INSTALLATION ######################
# Install MongoDB Following the Instructions at MongoDB Docs
# Ref: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

# Add the package verification key
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

# Add MongoDB to the repository sources list
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list

# Update the repository sources list once more
RUN apt-get update

# Install MongoDB package (.deb)
RUN apt-get install -y mongodb-org

# Create the default data directory
RUN mkdir -p /data/db

##################### INSTALLATION END #####################

RUN pip3 install awscli boto pymongo


ENV AWS_STORAGE_BUCKET_NAME test
ENV AWS_ACCESS_KEY_ID test
ENV AWS_SECRET_ACCESS_KEY test

################## BEGIN S3FUSE INSTALLATION ######################

ENV S3FS_VERSION=1.84 S3FS_SHA1=9322692aa797fcc6fefe300086e07b33bbc735c9

ADD *.sh /


##################### INSTALLATION END #####################


ADD entrypoint.sh /root/

COPY ./app /usr/src/app

RUN chmod +x /root/entrypoint.sh

ENV PATH=$PATH:/root/.local/bin/

WORKDIR /usr/src/app


ENTRYPOINT ["/root/entrypoint.sh"]
