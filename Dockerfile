FROM alpine:latest

ENVCOBBLER_VERSION 2.8.4

RUN apk add --update --no-cache \
      curl python2 py2-pip git nginx tftp-hpa supervisor syslinux curl-dev python2-dev musl-dev gcc make linux-headers && \
      pip --no-cache-dir install -U pip && \
      pip --no-cache-dir install six && \
      pip --no-cache-dir install jinja2 cheetah netaddr simplejson six urlgrabber setuptools pyyaml uwsgi pykickstart && \
      curl -O -L https://github.com/cobbler/cobbler/archive/v$COBBLER_VERSION.tar.gz && \
      tar -zxvf v$COBBLER_VERSION.tar.gz && \
      cd cobbler-$COBBLER_VERSION && \
      addgroup apache && \
      adduser -S -D -G apache -s /usr/bin/false apache && \
      make install && \
      mkdir /run/nginx && \
      mkdir /etc/supervisor.d && \
      mkdir /tftpboot && \
      mkdir /etc/uwsgi && \
      apk del gcc make git linux-headers && \
      cd .. && rm -rf cobbler-$COBBLER_VERSION v$COBBLER_VERSION.tar.gz

COPY nginx/cobbler.conf /etc/nginx/conf.d/default.conf
COPY uwsgi/* /etc/uwsgi/
COPY supervisor/*.ini /etc/supervisor.d/
COPY supervidor/supervisord.conf /etc/supervisord.conf
COPY start.sh /

RUN chmod 755 start.sh

EXPOSE 69 80

CMD /start.sh

