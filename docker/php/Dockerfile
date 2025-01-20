FROM php:8.1-fpm

ARG SERVER_ID=1

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    dos2unix \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Installation de Node.js et npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Installation des extensions PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuration du serveur
WORKDIR /var/www/html

# Copie et préparation du script d'entrée
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    dos2unix /usr/local/bin/docker-entrypoint.sh

ENV SERVER_ID=${SERVER_ID}

ENTRYPOINT ["bash", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"]