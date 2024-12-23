FROM debian:bookworm
RUN apt-get update && apt-get install --no-install-recommends -y \
		apache2 \
		apache2-utils \
		libapache2-mod-php \
		php \
		php-apcu \
		php-bcmath \
		php-bz2 \
		php-cli \
		php-common \
		php-curl \
		php-dev \
		php-gd \
		php-gmp \
		php-imagick \
		php-intl \
		php-json \
		php-ldap \
		php-mbstring \
		php-memcached \
		php-mysql \
		php-pear \
		php-redis \
		php-soap \
		php-xml \
		php-zip \
		php-ldap && \
		a2enmod headers proxy proxy_http php8.2
EXPOSE 80/tcp
CMD ["apache2ctl", "-D", "FOREGROUND"]
