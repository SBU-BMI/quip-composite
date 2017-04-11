# CaMicroscope Segment Curation Worker
# Install Mongo, Nodejs, Redis, Kue 

FROM     ubuntu:14.04
MAINTAINER Feiqiao Wang "feiqiao.wang@gmail.com"


### update
RUN apt-get -q update
RUN apt-get -q -y upgrade
RUN apt-get -q -y dist-upgrade
RUN apt-get -y install redis-server
RUN apt-get -y install nodejs npm
RUN npm install yargs   
RUN apt-get -y install git

WORKDIR /root/

#RUN git clone https://github.com/Automattic/kue.git

#WORKDIR /root/kue

RUN git clone https://github.com/camicroscope/OrderingService.git
WORKDIR /root/OrderingService

RUN npm install 

RUN  ln -s "$(which nodejs)" /usr/bin/node

RUN npm install -g forever


WORKDIR /root
COPY run.sh /root/
COPY redis.conf /etc/redis/redis.conf
CMD ["sh", "run.sh"]

#RUN forever start /root/OrderingService/node_modules/kue/bin/kue-dashboardai


# Install MongoDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org && \
  rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/data/db"]

# Define working directory.
WORKDIR /data

# Define default command.
#CMD ["mongod"]

#load script file and composite_worker.js file
RUN mkdir /tmp
WORKDIR /tmp
RUN git clone https://github.com/camicroscope/OrderingService.git

CMD["node composite_worder.js"]









