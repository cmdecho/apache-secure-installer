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
/usr/bin/uptime
EOF
chmod 440 /etc/sudoers.d/rizky-panel

# ======================
# Set up web directory and assets
# ======================
WEB="/var/www/html/rizky_web"
mkdir -p $WEB/assets

# ======================
# Create styles for the web panel
# ======================
cat <<'EOF' > $WEB/assets/style.css
body {
  margin: 0;
  font-family: Inter, Arial;
  background: #020617;
  color: #e5e7eb;
  display: flex;
}

.sidebar {
  width: 240px;
  background: #020617;
  border-right: 1px solid #1e293b;
  padding: 20px;
}

.sidebar h2 {
  color: #38bdf8;
}

.sidebar a {
  display: block;
  color: #cbd5f5;
  text-decoration: none;
  padding: 12px;
  border-radius: 8px;
}

.sidebar a:hover {
  background: #1e293b;
}

.main {
  flex: 1;
  padding: 30px;
}

.card {
  background: #020617;
  border: 1px solid #1e293b;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
}

button, input {
  padding: 12px;
  width: 100%;
  margin-top: 10px;
  border-radius: 8px;
  border: 1px solid #1e293b;
  background: #020617;
  color: white;
}

button {
  background: #38bdf8;
  color: black;
  font-weight: bold;
}

pre {
  background: black;
  padding: 15px;
  border-radius: 10px;
  overflow: auto;
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
    $error = "Login gagal";  
  }  
}  
?>  
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>  
  <link rel="stylesheet" href="assets/style.css">
</head>  
<body style="justify-content:center;align-items:center">  
  <div class="card" style="max-width:400px">  
    <h2>🔐 Rizky Panel Login</h2>  
    <form method="post">  
      <input type="hidden" name="csrf" value="<?=$_SESSION['csrf']?>">  
      <input name="user" placeholder="Username">  
      <input type="password" name="pass" placeholder="Password">  
      <button>Login</button>  
    </form>  
    <p style="color:red"><?=$error?></p>  
  </div>
</body>
</html>  
EOF

# ======================
# Create dashboard page
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
    <a href="actions.php">Root Actions</a>
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
    </div>
    <footer>© <?=date("Y")?> RIZKY MAULANA</footer>
  </div>
</body>
</html>  
EOF

# ======================
# Create root actions page
# ======================
cat <<'EOF' > $WEB/actions.php
<?php require "security.php"; ?>  
<!DOCTYPE html>
<html>
<head>  
  <title>Root Actions</title>  
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <div class="sidebar">
    <h2>Root Action</h2>
    <a href="dashboard.php">Dashboard</a>
    <a href="logout.php">Logout</a>
  </div>
  <div class="main">
    <form method="post">
      <button name="a" value="restart">Restart Apache</button>
      <button name="a" value="status">Apache Status</button>
      <button name="a" value="log">Apache Logs</button>
    </form>
    <pre>
      <?php  
      if (isset($_POST['a'])) {
        $cmd = [
          "restart" => "sudo systemctl restart apache2",
          "status" => "sudo systemctl status apache2",
          "log" => "sudo tail -n 50 /var/log/apache2/error.log"
        ];
        echo shell_exec($cmd[$_POST['a']] . " 2>&1");
      }
      ?>
    </pre>
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
chown -R www-data:www-data $WEB
chmod -R 755 $WEB

# Restart Apache to apply changes
systemctl restart apache2

# Output installation success
IP=$(hostname -I | awk '{print $1}')
echo "========================================"
echo " INSTALL SUCCESS"
echo " URL : http://$IP/rizky_web/login.php"
echo " USER: admin"
echo " PASS: RIZKY"
echo "========================================"
