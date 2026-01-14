#!/bin/bash

# ==================================================
# RIZKY PROFESSIONAL LINUX WEB PANEL
# Credit: RIZKY MAULANA
# Debian / Ubuntu / Linux Mint
# ==================================================

set -e

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Installing Rizky Professional Web Panel..."

# ======================
# Install required packages
# ======================
apt update -y
apt install -y apache2 php libapache2-mod-php sudo unzip ufw

# ======================
# Configure Apache
# ======================
systemctl enable apache2
systemctl start apache2
ufw allow 80/tcp || true

# ======================
# Create sudo rules for the web panel
# ======================
cat <<EOF > /etc/sudoers.d/rizky-panel
www-data ALL=(root) NOPASSWD: \
/bin/systemctl restart apache2, \
/bin/systemctl start apache2, \
/bin/systemctl stop apache2, \
/bin/systemctl status apache2, \
/usr/bin/tail /var/log/apache2/*.log, \
/bin/df, \
/usr/bin/free, \
/usr/bin/uptime, \
/usr/bin/htop, \
/bin/systemctl status
EOF
chmod 440 /etc/sudoers.d/rizky-panel

# ======================
# Set up web directory and assets
# ======================
WEB="/var/www/html/rizky_web"
mkdir -p $WEB/assets

# ======================
# Create styles for the web panel (Material Design)
# ======================
cat <<'EOF' > $WEB/assets/style.css
body {
  margin: 0;
  font-family: 'Roboto', sans-serif;
  background: #121212;
  color: #ffffff;
  display: flex;
  height: 100vh;
  flex-direction: column;
}

.sidebar {
  width: 240px;
  background: #263238;
  border-right: 1px solid #37474f;
  padding: 20px;
  position: fixed;
  height: 100%;
}

.sidebar h2 {
  color: #00bcd4;
}

.sidebar a {
  display: block;
  color: #b0bec5;
  text-decoration: none;
  padding: 12px;
  border-radius: 8px;
}

.sidebar a:hover {
  background: #37474f;
}

.main {
  flex: 1;
  margin-left: 240px;
  padding: 30px;
}

.card {
  background: #263238;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
  border: 1px solid #37474f;
}

button, input {
  padding: 12px;
  width: 100%;
  margin-top: 10px;
  border-radius: 8px;
  border: 1px solid #37474f;
  background: #00bcd4;
  color: white;
}

button {
  background: #00bcd4;
  color: black;
  font-weight: bold;
}

pre {
  background: #212121;
  padding: 15px;
  border-radius: 10px;
  overflow: auto;
  color: #b0bec5;
}

footer {
  background: #37474f;
  color: #b0bec5;
  padding: 10px;
  text-align: center;
  border-radius: 8px;
  margin-top: 20px;
}

footer p {
  margin: 0;
  font-size: 14px;
}
EOF

# ======================
# Create config file for the panel
# ======================
cat <<'EOF' > $WEB/config.php
<?php    
session_start();    
define("USER","admin");    
define("PASS_HASH", password_hash("RIZKY", PASSWORD_DEFAULT));    
if(!isset($_SESSION['csrf'])){    
  $_SESSION['csrf'] = bin2hex(random_bytes(32));    
}    
?>    
EOF

# ======================
# Create security check for login
# ======================
cat <<'EOF' > $WEB/security.php
<?php    
require "config.php";    
if(!isset($_SESSION['login'])){    
  header("Location: login.php");exit;    
}    
?>    
EOF

# ======================
# Create login page
# ======================
cat <<'EOF' > $WEB/login.php
<?php    
require "config.php";    
$error = "";    
if ($_SERVER["REQUEST_METHOD"] === "POST") {    
  if (hash_equals($_SESSION['csrf'], $_POST['csrf']) &&    
      $_POST['user'] === USER &&    
      password_verify($_POST['pass'], PASS_HASH)) {    
    $_SESSION['login'] = true;    
    header("Location: dashboard.php");    
    exit;    
  } else {    
    $error = "Login failed";    
  }    
}    
?>    
<!DOCTYPE html>    
<html>    
<head>    
  <title>Login</title>    
  <link rel="stylesheet" href="assets/style.css">    
</head>    
<body>    
  <div class="card" style="max-width:400px;margin:auto;margin-top:50px;">    
    <h2>🔐 Rizky Panel Login</h2>    
    <form method="post">    
      <input type="hidden" name="csrf" value="<?=$_SESSION['csrf']?>">    
      <input name="user" placeholder="Username" required>    
      <input type="password" name="pass" placeholder="Password" required>    
      <button>Login</button>    
    </form>    
    <p style="color:red"><?=$error?></p>    
  </div>    
</body>    
</html>    
EOF

# ======================
# Create password reset page
# ======================
cat <<'EOF' > $WEB/reset_password.php
<?php
require "security.php";
$error = "";
if ($_SERVER["REQUEST_METHOD"] === "POST") {
  if (hash_equals($_SESSION['csrf'], $_POST['csrf']) && $_POST['new_pass'] === $_POST['confirm_pass']) {
    // Hash new password and update the config
    $new_hash = password_hash($_POST['new_pass'], PASSWORD_DEFAULT);
    file_put_contents('config.php', str_replace(PASS_HASH, $new_hash, file_get_contents('config.php')));
    header("Location: dashboard.php");
    exit;
  } else {
    $error = "Passwords do not match.";
  }
}
?>
<!DOCTYPE html>
<html>
<head>
  <title>Reset Password</title>
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <div class="card" style="max-width:400px;margin:auto;margin-top:50px;">
    <h2>🔑 Reset Password</h2>
    <form method="post">
      <input type="hidden" name="csrf" value="<?=$_SESSION['csrf']?>">
      <input name="new_pass" type="password" placeholder="New Password" required>
      <input name="confirm_pass" type="password" placeholder="Confirm Password" required>
      <button>Reset Password</button>
    </form>
    <p style="color:red"><?=$error?></p>
  </div>
</body>
</html>
EOF

# ======================
# Create dashboard page (Improved)
# ======================
cat <<'EOF' > $WEB/dashboard.php
<?php require "security.php"; ?>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard</title>
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <div class="sidebar">
    <h2>Rizky Panel</h2>
    <a href="dashboard.php">Dashboard</a>
    <a href="reset_password.php">Reset Password</a>
    <a href="logout.php">Logout</a>
  </div>
  <div class="main">
    <h1>🖥 Web Server Dashboard</h1>
    <div class="card">
      <p><b>Apache:</b> <?=apache_get_version()?></p>
      <p><b>PHP:</b> <?=phpversion()?></p>
      <p><b>OS:</b> <?=php_uname()?></p>
      <p><b>Uptime:</b> <?=shell_exec("sudo uptime -p")?></p>
      <p><b>Disk:</b><pre><?=shell_exec("sudo df -h")?></pre></p>
      <p><b>Memory:</b><pre><?=shell_exec("sudo free -h")?></pre></p>
      <p><b>Processes:</b><pre><?=shell_exec("sudo htop -n 10")?></pre></p>
    </div>
    <footer>
      <p>© <?=date("Y")?> Rizky Maulana</p>
      <p>Web Server is built on Kali OS/Arch Linux</p>
    </footer>
  </div>
</body>
</html>
EOF

# ======================
# Create logout page
# ======================
cat <<'EOF' > $WEB/logout.php
<?php   
session_destroy();   
header("Location: login.php");   
?>    
EOF

# ======================
# Set correct permissions
# ======================
