FROM php:8.2-fpm

# Instalacja zależności systemowych
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libxslt-dev \
    libldap2-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libkrb5-dev \
    libc-client-dev \
    libssl-dev \
    unzip \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        intl \
        opcache \
        xsl \
        curl \
        ldap \
        mbstring \
        imap \
        soap \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Skopiuj własny plik konfiguracyjny OPcache (jeśli masz)
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Konfiguracja PHP
RUN printf "log_errors = On\nerror_log = /proc/self/fd/2\ndisplay_errors = Off\n" > /usr/local/etc/php/conf.d/90-log-errors.ini \
    && printf "upload_max_filesize=150M\npost_max_size=150M\n" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "date.timezone=Europe/Warsaw" > /usr/local/etc/php/conf.d/timezone.ini

# Domyślna strefa czasowa
ENV TZ=Europe/Warsaw
