FROM alpine
LABEL Maintainer="Christian Beneke <c.beneke@wirelab.org>" \
      Description="Lightweight container for Grav based on alpine linux"

RUN apk --no-cache add git nginx php7 php7-fpm php7-ctype php7-curl php7-dom \
      php7-gd php7-json php7-mbstring php7-openssl php7-session php7-simplexml \
      php7-xml php7-zip php7-apcu php7-opcache php7-yaml supervisor && \
    mkdir -p /app && chown nginx:nginx /app

WORKDIR /app
ENV GRAV_VERSION='1.4.8'
RUN wget https://github.com/getgrav/grav/releases/download/${GRAV_VERSION}/grav-admin-v${GRAV_VERSION}.zip && \
    unzip grav-admin-v${GRAV_VERSION}.zip && \
    mv grav-admin/* grav-admin/.htaccess . && \
    rm -r grav-admin-v${GRAV_VERSION}.zip grav-admin && \
    bin/gpm install -f -y admin clean-blog git-sync && \
    chown -R nginx:nginx /app

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/99-custom.ini

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
