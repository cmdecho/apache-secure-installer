#!/bin/bash

# ==================================================
# Apache Web Panel - FULL CLEAN UNINSTALL
# Credit: RIZKY MAULANA
# ==================================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan script ini dengan sudo"
  exit 1
fi

echo "🧹 Removing Apache Web Panel..."

# Stop services
systemctl stop apache2 || true
systemctl disable apache2 || true

# Remove packages
apt purge apache2 apache2-utils apache2-bin apache2.2-common -y || true
apt purge php php-* libapache2-mod-php libapache2-mod-wsgi-py3 -y || true

# Remove leftover config
rm -rf /etc/apache2
rm -rf /var/www/html/rizky_web

# Firewall cleanup
if command -v ufw >/dev/null 2>&1; then
  ufw delete allow 80/tcp || true
fi

# Clean system
apt autoremove -y
apt autoclean -y

echo "===================================="
echo " UNINSTALL COMPLETE"
echo " Apache, PHP, Web Panel removed"
echo " System clean ✔"
echo "===================================="
