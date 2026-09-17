#!/bin/bash
# Script konfigurasi untuk ubuntu container
# Jalankan ini di dalam container dengan: bash setup-ubuntu-container.sh

echo "=== Mulai Konfigurasi Ubuntu Container ==="

# Update package lists
echo "1. Update package lists..."
apt update

# Install basic utilities
echo "2. Install basic utilities (curl, wget, vim, git)..."
apt install -y curl wget vim git

# Install web server (Apache)
echo "3. Install Apache web server..."
apt install -y apache2

# Install PHP
echo "4. Install PHP dan modul..."
apt install -y php php-mysql php-curl php-gd php-mbstring php-xml php-zip

# Configure Apache
echo "5. Konfigurasi Apache..."
# Enable mod_rewrite
a2enmod rewrite

# Set up a simple index page
echo "<h1>Hello dari Custom Ubuntu Container</h1>" > /var/www/html/index.html
echo "<p>Container ini dikonfigurasi dengan Apache + PHP</p>" >> /var/www/html/index.html

# Create a PHP info file
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Start Apache (jika perlu)
service apache2 start

echo "=== Konfigurasi Selesai ==="
echo "Apache dan PHP telah terinstall"
echo "Test PHP dengan mengakses /info.php"
