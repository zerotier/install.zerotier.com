FROM nginx:1.30.7
COPY htdocs /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
