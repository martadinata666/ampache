FROM alpine:latest
WORKDIR /var/www/localhost/htdocs/
ADD  https://github.com/ampache/ampache/releases/download/4.2.6/ampache-4.2.6_all.zip /var/www/localhost/htdocs/
#COPY ampache-4.2.6_all.zip .
COPY ./php.ini /etc/php7/php.ini
COPY ./httpd.conf /etc/apache2/httpd.conf
RUN apk add  --no-cache nano \
			   apache2 unzip \
			   php7-apache2 php7-json php7-dom php7-curl php7-iconv php7-openssl \
			   php7-pdo_mysql php7-session php7-ctype php7-gd php7-mbstring php7-zip
RUN unzip ampache-4.2.6_all.zip -d /var/www/localhost/htdocs/
RUN adduser --disabled-password --uid 1000 ampache
RUN rm /var/www/localhost/htdocs/index.html
RUN rm /var/www/localhost/htdocs/ampache-4.2.6_all.zip
EXPOSE 80
CMD /usr/sbin/httpd -DFOREGROUND -f /etc/apache2/httpd.conf
#CMD /usr/sh
