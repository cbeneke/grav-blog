FROM alpine
LABEL Maintainer="Christian Beneke <c.beneke@wirelab.org>" \
      Description="Lightweight container for Grav based on alpine linux"

RUN apk --no-cache add git nginx php7 php7-fpm php7-ctype php7-curl php7-dom \
      php7-gd php7-json php7-ldap php7-mbstring php7-openssl php7-session \
      php7-simplexml php7-xml php7-zip php7-apcu php7-opcache php7-yaml \
      supervisor && \
    mkdir -p /app && chown nginx:nginx /app

WORKDIR /app
ENV GRAV_VERSION='1.5.0'
RUN wget https://github.com/getgrav/grav/releases/download/${GRAV_VERSION}/grav-admin-v${GRAV_VERSION}.zip && \
    unzip grav-admin-v${GRAV_VERSION}.zip && \
    mv grav-admin/* grav-admin/.htaccess . && \
    bin/gpm install -f -y admin auto-author auto-date cookieconsent feed \
      git-sync login-ldap minify-html readingtime && \
    rm -rf grav-admin-v${GRAV_VERSION}.zip grav-admin user/themes user/pages \
      user/config/* && \
    cd user && \
    git init && \
    git config user.name GitSync && \
    git config user.author gitsync && \
    git config user.email changeme@example.org

COPY config/gitignore /app/user/.gitignore
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/99-custom.ini

RUN chown -R nginx:nginx /app

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
