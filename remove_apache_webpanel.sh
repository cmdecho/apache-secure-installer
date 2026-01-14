#!/bin/bash
# ==================================================
# RIZKY PROFESSIONAL LINUX WEB PANEL - UNINSTALLER
# Credit: RIZKY MAULANA
# Debian / Ubuntu / Linux Mint
# ==================================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🧹 Removing Rizky Professional Web Panel..."

# ======================
# STOP APACHE
# ======================
systemctl stop apache2 || true
systemctl disable apache2 || true

# ======================
# REMOVE WEB FILES
# ======================
echo "🗑 Removing web files..."
rm -rf /var/www/html/rizky_web

# ======================
# REMOVE SUDO RULE
# ======================
echo "🗑 Removing sudoers rule..."
rm -f /etc/sudoers.d/rizky-panel

# ======================
# FIREWALL CLEAN
# ======================
echo "🛡 Removing UFW firewall rule..."
if command -v ufw >/dev/null 2>&1; then
  ufw delete allow 80/tcp || true
fi

# ======================
# REMOVE APACHE AND PHP
# ======================
echo "🗑 Removing Apache2 and PHP..."
apt purge -y apache2 apache2-utils apache2-bin apache2-data php libapache2-mod-php

# ======================
# REMOVE DEPENDENCIES
# ======================
echo "🗑 Removing unnecessary packages..."
apt autoremove -y

# ======================
# REMOVE CONFIGURATION
# ======================
echo "🗑 Removing configuration files..."
rm -f /etc/apache2/sites-available/000-default.conf
rm -f /etc/apache2/ports.conf
rm -f /etc/apache2/apache2.conf

# ======================
# CLEAN CACHE
# ======================
echo "🧹 Cleaning package cache..."
apt clean

# ======================
# RELOAD SYSTEMD
# ======================
echo "🔄 Reloading systemd..."
systemctl daemon-reload

# ======================
# FINAL STEPS
# ======================
echo "========================================"
echo "✅ Uninstallation completed successfully!"
echo "✔ All files and configurations have been removed."
echo "========================================"
