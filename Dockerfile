FROM php:8.2-cli

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip libpng-dev libonig-dev libxml2-dev libpq-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crea directorio de la app
WORKDIR /var/www/html

# Copia el contenido del proyecto
COPY . .

# Instala dependencias Laravel
RUN composer install --no-dev --optimize-autoloader

# Crea cache de configuración
RUN php artisan config:cache

# Puerto en el que Laravel escuchará
EXPOSE 8000

# Comando para iniciar Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
