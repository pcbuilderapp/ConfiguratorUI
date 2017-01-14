FROM nginx:1.11.6

COPY build/web/. /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/pcbuilder.template

ENV BACKEND_ADDRESS=""

ENTRYPOINT [ "bash", "-c", "envsubst < /etc/nginx/conf.d/pcbuilder.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'" ]
