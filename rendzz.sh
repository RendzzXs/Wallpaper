#!/bin/bash

PTERO_DIR="/var/www/pterodactyl"

echo "🚑 RENDZZ PANEL EMERGENCY REPAIR STARTING..."

cd /var/www || exit 1

# Backup config & env
echo "📦 Backup .env..."
cp $PTERO_DIR/.env /root/pterodactyl_env_backup 2>/dev/null

# Stop web
php $PTERO_DIR/artisan down 2>/dev/null

# Remove broken core (but keep .env & storage)
echo "🧹 Cleaning broken core files..."
cd /var/www
rm -rf pterodactyl_new
git clone https://github.com/pterodactyl/panel.git pterodactyl_new

cd pterodactyl_new

# Install composer deps
echo "📦 Installing composer..."
apt update -y
apt install curl unzip git -y

curl -sS https://getcomposer.org/installer | php
php composer.phar install --no-dev --optimize-autoloader

# Copy old env
echo "🔁 Restoring .env..."
cp /root/pterodactyl_env_backup .env

# Set permissions
chmod -R 755 storage bootstrap/cache

# Install node if missing
if ! command -v npm &> /dev/null
then
    echo "📦 Installing NodeJS..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs
fi

# Build assets
echo "⚙️ Building panel..."
npm install
npm run build

# Replace old panel
echo "🔁 Replacing old panel files..."
cd /var/www
rm -rf pterodactyl
mv pterodactyl_new pterodactyl

cd pterodactyl

php artisan key:generate --force
php artisan migrate --seed --force
php artisan config:clear
php artisan cache:clear
php artisan view:clear

chown -R www-data:www-data /var/www/pterodactyl/*

systemctl restart nginx
systemctl restart php8.1-fpm 2>/dev/null
systemctl restart php8.2-fpm 2>/dev/null

php artisan up

echo "✅ PANEL REPAIRED SUCCESSFULLY!"
echo "🔄 Refresh browser (CTRL+SHIFT+R)"
