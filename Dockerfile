FROM alpine:3.13
ARG RELEASE=4.4.0
WORKDIR /var/www/localhost/htdocs/
RUN adduser --disabled-password --uid 1000 ampache
#ADD https://github.com/ampache/ampache/releases/download/$RELEASE/ampache-$RELEASE\_all.zip /var/www/localhost/htdocs/

COPY ./php.ini /etc/php7/php.ini
COPY ./httpd.conf /etc/apache2/httpd.conf
RUN apk add  --no-cache nano \
			   apache2 apache2-ssl unzip \
			   php7-apache2 php7-json php7-dom php7-curl php7-iconv php7-openssl \
			   php7-pdo_mysql php7-session php7-ctype php7-gd php7-mbstring php7-zip php7-simplexml wget ffmpeg
RUN chown -R ampache:ampache /var/www/localhost/htdocs/
ADD --chown=ampache:ampache https://github.com/ampache/ampache/releases/download/$RELEASE/ampache-$RELEASE\_all.zip
RUN unzip ampache.zip -d /var/www/localhost/htdocs/ && rm /var/www/localhost/htdocs/ampache-$RELEASE\_all.zip && rm /var/www/localhost/htdocs/index.html

EXPOSE 80
EXPOSE 443

#USER ampache

CMD /usr/sbin/httpd -DFOREGROUND
#CMD /usr/sh
