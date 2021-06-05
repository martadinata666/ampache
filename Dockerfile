FROM registry.gitlab.com/dedyms/alpine:edge
ARG RELEASE
ENV AMPACHE_VERSION=$RELEASE
COPY ./php.ini /etc/php7/php.ini
COPY ./httpd.conf /etc/apache2/httpd.conf
RUN apk add  --no-cache    apache2 apache2-ssl unzip wget \
			   php7-apache2 php7-json php7-dom php7-curl php7-iconv php7-openssl php7-gettext \
			   php7-pdo_mysql php7-session php7-ctype php7-gd php7-mbstring php7-zip php7-simplexml && rm /var/www/localhost/htdocs/index.html
WORKDIR /var/www/localhost/htdocs/
# Let user extract web data
RUN chown -R $CONTAINERUSER:$CONTAINERUSER /var/www/localhost/htdocs/
USER $CONTAINERUSER
RUN wget  https://github.com/ampache/ampache/releases/download/$RELEASE/ampache-$RELEASE\_all.zip && \
    unzip ampache-$RELEASE\_all.zip -d . && rm /var/www/localhost/htdocs/ampache-$RELEASE\_all.zip && \
    rm -rf ./lib/vendor/james-heinrich/getid3/.git/ && \
    rm -rf ./lib/vendor/swisnl/jQuery-contextMenu/.git/ && \
    rm -rf ./lib/vendor/swisnl/jQuery-contextMenu/documentation/ && \
    rm -rf ./lib/vendor/scaron/prettyphoto/.git/ && \
    rm -rf ./locale/ && mkdir locale/
# Port
EXPOSE 80
EXPOSE 443

# Switch back
USER root
CMD /usr/sbin/httpd -DFOREGROUND
