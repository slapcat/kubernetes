FROM ghcr.io/slapcat/apache-php:latest
RUN apt-get update && apt-get install --no-install-recommends -y \
		sudo \
		curl \
		gnupg \
		bzip2 \
		dirmngr \
		ssl-cert \
		ca-certificates \
		libmagickcore-6.q16-6-extra

ENV CLI_INI_DIR /etc/php/8.2/cli/conf.d
ENV APACHE_INI_DIR /etc/php/8.2/apache2/conf.d

RUN sed -i 's@/var/www/html@/var/www/html/nextcloud@' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's@/var/www/html@/var/www/html/nextcloud@' /etc/apache2/sites-available/default-ssl.conf && \
    sed -i 's@/etc/ssl/certs/ssl-cert-snakeoil.pem@/etc/ssl/nextcloud/tls.crt@' /etc/apache2/sites-available/default-ssl.conf && \
    sed -i 's@/etc/ssl/private/ssl-cert-snakeoil.key@/etc/ssl/nextcloud/tls.key@' /etc/apache2/sites-available/default-ssl.conf

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
    } > "${APACHE_INI_DIR}/99-override.ini"; \
    \
    { \
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
    } > "${CLI_INI_DIR}/99-override.ini";


RUN a2enmod headers rewrite remoteip ; \
    { \
     echo 'RemoteIPHeader X-Real-IP'; \
     echo 'RemoteIPInternalProxy 10.0.0.0/8'; \
     echo 'RemoteIPInternalProxy 172.16.0.0/12'; \
     echo 'RemoteIPInternalProxy 192.168.0.0/16'; \
    } > /etc/apache2/conf-available/remoteip.conf; \
    a2enconf remoteip

# set apache config
RUN { \
     echo 'LimitRequestBody 1073741824'; \
     echo '<Directory /var/www/html/nextcloud>'; \
     echo 'AllowOverride All'; \
     echo '</Directory>'; \
    } > /etc/apache2/conf-available/nextcloud.conf; \
    a2enconf nextcloud && \
    a2enmod ssl && \
    a2ensite default-ssl

RUN set -ex; \
    curl -fsSL -o nextcloud.tar.bz2.asc "https://download.nextcloud.com/server/releases/nextcloud-31.0.9.tar.bz2.asc"; \
    curl -fsSL -o nextcloud.tar.bz2 "https://download.nextcloud.com/server/releases/nextcloud-31.0.9.tar.bz2"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 28806A878AE423A28372792ED75899B9A724937A; \
    gpg --batch --verify nextcloud.tar.bz2.asc nextcloud.tar.bz2; \
    tar -xjf nextcloud.tar.bz2 -C /var/www/html/; \
    gpgconf --kill all; \
    rm nextcloud.tar.bz2.asc nextcloud.tar.bz2; \
    rm -rf "$GNUPGHOME" /var/www/html/nextcloud/updater; \
    mkdir -p /var/www/html/nextcloud/data; \
    mkdir -p /var/www/html/nextcloud/custom_apps; \
    chmod +x /var/www/html/nextcloud/occ; \
    chown www-data:www-data -R /var/www/html; \
    apt autoremove; \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80/tcp
CMD ["apache2ctl", "-D", "FOREGROUND"]
