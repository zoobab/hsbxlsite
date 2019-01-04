FROM jojomi/hugo
RUN apk update && apk add nginx
RUN mkdir -p /var/www/blog
COPY nginx.conf /etc/nginx/nginx.conf
COPY . /var/www/blog
WORKDIR /var/www/blog
RUN hugo
EXPOSE 80
ENTRYPOINT ["/usr/sbin/nginx","-c","/etc/nginx/nginx.conf"]
