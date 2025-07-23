FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mysqli soap

# Enable apache modules
RUN a2enmod rewrite

# Copy and unzip Sendy files
COPY sendy-6.1.3.zip /tmp/sendy.zip
RUN unzip /tmp/sendy.zip -d /var/www/html/ && rm /tmp/sendy.zip

# Set permissions
RUN sed -i "s#define('APP_PATH', getenv('SENDY_PROTOCOL') . '://' . getenv('SENDY_FQDN'));#define('APP_PATH', getenv('APP_URL'));#g" /var/www/html/includes/config.php
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

