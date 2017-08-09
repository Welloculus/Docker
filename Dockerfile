FROM ubuntu:14.04

# Update the repository sources list

RUN apt-get update
LABEL maintainer "Welloculus <https://github.com/welloculus>"

RUN apt install -y git && git clone https://github.com/Welloculus/kibana.git -b 5.5

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get -y autoclean

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.11.1

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm init --yes

# confirm installation
RUN node -v
RUN npm -v

#install kibana, change permission of folder and file
RUN chmod 777 kibana && cd /kibana && chmod 777 package.json && ls -l && npm install

#install grunt
RUN npm install -g grunt-cli

EXPOSE 9200
EXPOSE 5601

