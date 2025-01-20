#!/bin/bash
set -e

cd /var/www/html

# Attente que MySQL soit prêt
until nc -z -v -w30 laravel_mysql 3306
do
  echo "Waiting for database connection..."
  sleep 5
done

# Création/copie du fichier .env s'il n'existe pas
if [ ! -f ".env" ]; then
    cp .env.example .env
    # Configuration de la base de données
    sed -i 's/DB_HOST=.*/DB_HOST=laravel_mysql/' .env
    sed -i 's/DB_DATABASE=.*/DB_DATABASE=laravel/' .env
    sed -i 's/DB_USERNAME=.*/DB_USERNAME=laravel/' .env
    sed -i 's/DB_PASSWORD=.*/DB_PASSWORD=secret/' .env
    # Configuration du mail
    sed -i 's/MAIL_HOST=.*/MAIL_HOST=laravel_mailhog/' .env
    sed -i 's/MAIL_PORT=.*/MAIL_PORT=1025/' .env
    # Ajout du SERVER_ID
    echo "SERVER_ID=$SERVER_ID" >> .env
fi

# Installation des dépendances
composer update --no-interaction --optimize-autoloader
npm install
npm run build

# Configuration de Laravel et nettoyage des caches
php artisan key:generate --force
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan storage:link

# Modifier le fichier welcome.blade.php pour ajouter le titre du serveur
sed -i '/<div class="max-w-7xl mx-auto p-6 lg:p-8">/a\    <h1 class="text-4xl font-bold text-gray-100 text-center mb-8">Serveur {{ env('\''SERVER_ID'\'') }}</h1>' resources/views/welcome.blade.php

# Migrations et seeds (uniquement pour le serveur 1)
if [ "$SERVER_ID" = "1" ]; then
    php artisan migrate:fresh --seed --force
fi

exec "$@"