FROM wordpress:latest

LABEL maintainer="gonzalo4@gmail.com"

# Get packages that we need in container
RUN rm /etc/apt/preferences.d/no-debian-php \
  && apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
     libxml2-dev \
     php7.0-soap \
     php-pear \
  && pear config-set preferred_state alpha \
  && apt-get clean -y \
  && docker-php-ext-install soap \
  && apt-get autoremove -y

#Install and config xdebug
RUN pecl install xdebug \
  && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.idekey = PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.default_enable = 0" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_connect_back = 0" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.profiler_enable = 0" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_host = 192.168.1.4" >> /usr/local/etc/php/conf.d/xdebug.ini

# Memcached
RUN apt-get install -y memcached libmemcached-dev

# Delete source & builds deps so it does not hang around in layers taking up space
RUN pecl clear-cache \
    && rm -Rf "$(pecl config-get temp_dir)/*" \
    && docker-php-source delete \
    && apt-get purge -y --auto-remove && apt-get clean all

# PHP Version
RUN php -v

# Set timezone
RUN echo "Argentina/Buenos_Aires" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Add some custom config
COPY ./config/php.ini /usr/local/etc/php/php.ini
