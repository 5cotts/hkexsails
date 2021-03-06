FROM node

ENV VER=${VER:-master} \
    REPO=https://github.com/twhtanghk/hkexsails \
    APP=/usr/src/app

RUN apt-get update \
&&  apt-get install -y git \
&&  apt-get clean \
&&  git clone -b $VER $REPO $APP

WORKDIR $APP

RUN npm install
	
EXPOSE 1337

ENTRYPOINT npm start
