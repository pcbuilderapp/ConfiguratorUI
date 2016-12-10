FROM debian:jessie-slim

RUN apt-get update && apt-get dist-upgrade
RUN apt-get install nginx

WORKDIR /pcbuilder

COPY build/web/. /pcbuilder/
COPY nginx.conf /etc/nginx/sites-available/pcbuilder
RUN rm /etc/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/pcbuilder /etc/sites-enabled/default

CMD []
ENTRYPOINT ["/usr/bin/nginx"]
