FROM php:8.4-apache

RUN apt-get update \
        && apt-get install --no-install-recommends -y \
            wget \
            sudo \
            curl \
            gnupg \
            bzip2 \
            dirmngr \
            ssl-cert \
            ca-certificates \
            libmagickcore-7.q16-10-extra \
        && wget -O /usr/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
        && chmod +x /usr/bin/install-php-extensions \
        && install-php-extensions apcu bcmath bz2 ldap gd gmp imagick intl memcached mysqli redis soap zip \
        && a2enmod headers proxy proxy_http rewrite remoteip ssl


RUN { \
        echo 'RemoteIPHeader X-Forwarded-For'; \
        echo 'RemoteIPInternalProxy 10.0.0.0/8'; \
        echo 'RemoteIPInternalProxy 172.16.0.0/12'; \
        echo 'RemoteIPInternalProxy 192.168.0.0/16'; \
    } > /etc/apache2/conf-enabled/remoteip.conf


RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=32'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=256'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.jit=1255'; \
        echo 'opcache.jit_buffer_size=128M'; \
        echo 'memory_limit=-1'; \
        echo 'upload_max_filesize=16G'; \
        echo 'post_max_size=16G'; \
        echo 'apc.enable_cli=1'; \
        echo 'output_buffering = off'; \
    } > /usr/local/etc/php/conf.d/99-override.ini;

EXPOSE 80/tcp
EXPOSE 443/tcp
CMD ["apache2ctl", "-D", "FOREGROUND"]
