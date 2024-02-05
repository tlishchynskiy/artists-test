FROM php:8.3-fpm AS base

ARG PUID
ENV PUID ${PUID}
ARG PGID
ENV PGID ${PGID}
ARG USER
ENV USER ${USER}

USER root
WORKDIR /workspace

# timezone environment
ENV TZ=UTC \
  # locale
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8 \
  # composer environment
  COMPOSER_ALLOW_SUPERUSER=1

COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $PUID -d /home/$USER $USER
RUN mkdir -p /home/$USER/.composer && \
    chown -R $USER:$USER /home/$USER

RUN <<EOF
  apt-get update
  apt-get -y install --no-install-recommends \
    locales \
    unzip \
    libzip-dev \
    libicu-dev \
    libonig-dev
  locale-gen en_US.UTF-8
  localedef -f UTF-8 -i en_US en_US.UTF-8
  docker-php-ext-install \
    intl \
    pdo_mysql \
    zip \
    bcmath
  composer config -g process-timeout 3600
  composer config -g repos.packagist composer https://packagist.org
EOF

# Node.js, NPM
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs
RUN npm install npm@latest -g

USER worker

FROM base AS development

USER root
RUN <<EOF
  apt-get -y install --no-install-recommends \
    default-mysql-client
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

COPY ./.docker/php/php.development.ini /usr/local/etc/php/php.ini

# Xdebug
RUN <<EOF
  pecl install xdebug
  docker-php-ext-enable xdebug
EOF

COPY ./.docker/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

USER worker

FROM base AS deploy

USER root
COPY ./.docker/php/php.deploy.ini /usr/local/etc/php/php.ini

USER worker
COPY ./ /workspace

USER root
RUN <<EOF
  composer install -q -n --no-ansi --no-dev --no-scripts --no-progress --prefer-dist
  chmod -R 777 storage bootstrap/cache
  php artisan optimize:clear
  php artisan optimize
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

USER worker
