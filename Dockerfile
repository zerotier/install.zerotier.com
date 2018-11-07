FROM nginx
COPY htdocs /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
