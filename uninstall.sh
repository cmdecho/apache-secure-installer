#!/bin/bash

# ==================================================
# RIZKY PROFESSIONAL LINUX WEB PANEL - UNINSTALLER
# Credit: RIZKY MAULANA
# Debian / Ubuntu / Linux Mint
# ==================================================

set -e

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Uninstalling Rizky Professional Web Panel..."

# ======================
# Stop and Disable Services
# ======================
echo "🛑 Stopping and disabling services..."
systemctl stop apache2
systemctl disable apache2

systemctl stop mysql
systemctl disable mysql

systemctl stop redis-server
systemctl disable redis-server

systemctl stop vsftpd
systemctl disable vsftpd

systemctl stop php7.4-fpm
systemctl disable php7.4-fpm

echo "✔️ Services stopped and disabled."

# ======================
# Remove Installed Packages
# ======================
echo "🧹 Removing installed packages..."

apt remove --purge -y apache2 mysql-server php libapache2-mod-php sudo unzip ufw python3 python3-pip redis-server vsftpd curl wget \
    php-mysql php-cli php-curl php-mbstring php-xml php-json php-zip php-gd php-fpm \
    git unzip certbot python3-certbot-apache phpmyadmin composer node
