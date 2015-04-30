FROM 		progrium/busybox
MAINTAINER 	Jeff Lindsay <progrium@gmail.com>

ADD https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip

ADD https://get.docker.io/builds/Linux/x86_64/docker-1.5.0 /bin/docker
RUN chmod +x /bin/docker

ADD ./deps/base64 /bin/base64
RUN chmod +x /bin/base64

RUN opkg-install curl bash

RUN curl -o /usr/bin/jq http://stedolan.github.io/jq/download/linux64/jq \
      && chmod +x /usr/bin/jq


ADD ./consul_deploy.sh /deploy/
ONBUILD ADD ./consul_deploy.sh /deploy/

ADD ./start /bin/start

ENV SHELL /bin/bash

CMD ["/bin/start"]
