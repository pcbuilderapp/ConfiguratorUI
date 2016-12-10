FROM nginx:1.11.6

COPY build/web/. /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
