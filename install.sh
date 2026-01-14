#!/bin/bash

# ==================================================
# RIZKY PROFESSIONAL LINUX WEB PANEL
# Credit: RIZKY MAULANA
# Debian / Ubuntu / Linux Mint
# ==================================================

set -e

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Installing Rizky Professional Web Panel..."

# ======================
# Install Dependencies
# ======================
apt update -y
apt install -y apache2 mysql-server php libapache2-mod-php sudo unzip ufw python3 python3-pip redis-server vsftpd curl wget \
    php-mysql php-cli php-curl php-mbstring php-xml php-json php-zip php-gd php-fpm \
    git unzip certbot python3-certbot-apache

# ======================
# Setup Apache
# ======================
systemctl enable apache2
systemctl start apache2

# ======================
# Setup MySQL
# ======================
echo "🔐 Setting up MySQL root password..."
MYSQL_ROOT_PASSWORD="RIZKY" # Ganti dengan password yang diinginkan
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';"

# ======================
# Setup Redis
# ======================
systemctl enable redis-server
systemctl start redis-server
echo "✔️ Redis server installed and running!"

# ======================
# Setup PHP-FPM (Optional for better performance)
# ======================
systemctl enable php7.4-fpm
systemctl start php7.4-fpm

# ======================
# Setup vsftpd (FTP Server)
# ======================
systemctl enable vsftpd
systemctl start vsftpd
echo "✔️ FTP Server (vsftpd) installed and running!"

# ======================
# Setup SSL (Certbot for Let's Encrypt)
# ======================
echo "🔒 Setting up SSL with Let's Encrypt..."
certbot --apache --agree-tos --email your-email@example.com -d your-domain.com

# ======================
# Install Monitoring Tools (htop, net-tools)
# ======================
apt install -y htop iftop nmap

# ======================
# Setup Firewall (UFW)
# ======================
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw enable
echo "✔️ UFW firewall configured!"

# ======================
# Install Node.js for JavaScript Apps
# ======================
curl -sL https://deb.nodesource.com/setup_16.x | bash -
apt install -y nodejs
echo "✔️ Node.js installed!"

# ======================
# Install Python 3
# ======================
pip3 install --upgrade pip

# ======================
# Install PHPMyAdmin (for MySQL management)
# ======================
echo "🔧 Installing PHPMyAdmin..."
apt install -y phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
systemctl restart apache2
echo "✔️ PHPMyAdmin installed!"

# ======================
# Install Adminer (Alternative to PHPMyAdmin)
# ======================
echo "🔧 Installing Adminer..."
mkdir /var/www/html/adminer
wget "https://www.adminer.org/latest.php" -O /var/www/html/adminer/index.php
echo "✔️ Adminer installed!"

# ======================
# Install Composer (PHP Dependency Manager)
# ======================
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
echo "✔️ Composer installed!"

# ======================
# Setup Web Dashboard with Wallpaper
# ======================
echo "🖼️ Creating Dashboard with wallpaper..."
mkdir -p /var/www/html/dashboard
echo "<html>
<head>
    <title>Rizky Web Dashboard</title>
    <style>
        body {
            background-image: url('https://www.example.com/windows11-wallpaper.jpg'); /* Ganti dengan URL wallpaper Windows 11 */
            background-size: cover;
            font-family: Arial, sans-serif;
            color: white;
            text-align: center;
            padding: 50px;
        }
        h1 {
            font-size: 48px;
        }
        .container {
            margin-top: 20px;
            background: rgba(0, 0, 0, 0.6);
            padding: 20px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <h1>Welcome to Rizky Web Panel</h1>
    <div class='container'>
        <h2>Apache2 + MySQL + Redis + Python Dashboard</h2>
        <p>System Status: Active</p>
    </div>
</body>
</html>" > /var/www/html/dashboard/index.html

# ======================
# Setup Login Page
# ======================
echo "🔐 Setting up login page..."
echo "<html>
<head>
    <title>Login to Web Panel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class='login-container'>
        <h2>Login</h2>
        <form action='dashboard.html' method='post'>
            <input type='text' name='username' placeholder='Username' required>
            <input type='password' name='password' placeholder='Password' required>
            <button type='submit'>Login</button>
        </form>
    </div>
</body>
</html>" > /var/www/html/login.html

# ======================
# Restart Apache
# ======================
systemctl restart apache2

# ======================
# Final Message
# ======================
echo "🚀 Web Panel has been successfully installed! Access it via: http://localhost/dashboard"
echo "Login Page: http://localhost/login.html"
