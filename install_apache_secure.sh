#!/bin/bash

# =====================================================
# RIZKY LINUX WEB SERVER PANEL - AUTO INSTALLER
# Credit : RIZKY MAULANA
# =====================================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Installing Rizky Web Server Panel..."

# ----------------------
# Install packages
# ----------------------
apt update -y
apt install apache2 php libapache2-mod-php sudo -y

systemctl enable apache2
systemctl start apache2

# ----------------------
# SUDO PERMISSION
# ----------------------
echo "www-data ALL=(ALL) NOPASSWD:/bin/systemctl restart apache2,/bin/systemctl start apache2,/bin/systemctl stop apache2,/usr/bin/a2ensite,/bin/systemctl reload apache2" > /etc/sudoers.d/rizky-panel
chmod 440 /etc/sudoers.d/rizky-panel

# ----------------------
# Web directory
# ----------------------
WEB="/var/www/html/rizky_web"
mkdir -p $WEB/assets

# ----------------------
# STYLE
# ----------------------
cat <<'EOF' > $WEB/assets/style.css
*{box-sizing:border-box;font-family:Inter,Segoe UI,Arial}
body{margin:0;background:linear-gradient(135deg,#020617,#0f172a);color:#e5e7eb}
.topbar{height:52px;background:#020617;border-bottom:1px solid #1e293b;display:flex;align-items:center;padding:0 20px;font-weight:600;color:#38bdf8}
.desktop{display:flex;height:calc(100vh - 52px)}
.sidebar{width:260px;background:#020617;border-right:1px solid #1e293b;padding:20px}
.sidebar h2{color:#38bdf8;margin-bottom:25px}
.sidebar a{display:block;color:#cbd5f5;text-decoration:none;padding:12px;border-radius:10px;margin-bottom:8px}
.sidebar a:hover{background:#1e293b}
.main{flex:1;padding:30px;overflow:auto}
.window{background:#020617;border:1px solid #1e293b;border-radius:16px;padding:20px;margin-bottom:20px}
.window-title{font-weight:700;color:#38bdf8;margin-bottom:15px}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px}
.card{background:#020617;border:1px solid #1e293b;border-radius:12px;padding:15px}
button{padding:12px;border:none;border-radius:10px;background:#38bdf8;font-weight:700;cursor:pointer}
.footer{text-align:center;color:#64748b;margin-top:40px}
EOF

# ----------------------
# CONFIG
# ----------------------
cat <<'EOF' > $WEB/config.php
<?php
session_start();
define("USER","admin");
define("PASS",password_hash("RIZKY",PASSWORD_DEFAULT));
if(!isset($_SESSION['csrf'])) $_SESSION['csrf']=bin2hex(random_bytes(32));
?>
EOF

# ----------------------
# SECURITY
# ----------------------
cat <<'EOF' > $WEB/security.php
<?php
require "config.php";
if(!isset($_SESSION['login'])){header("Location: login.php");exit;}
?>
EOF

# ----------------------
# LOGIN
# ----------------------
cat <<'EOF' > $WEB/login.php
<?php
require "config.php";
$error="";
if($_SERVER["REQUEST_METHOD"]=="POST"){
if($_POST['username']==USER && password_verify($_POST['password'],PASS)){
$_SESSION['login']=true;header("Location: dashboard.php");exit;
}else{$error="Login gagal";}
}
?>
<!DOCTYPE html>
<html><head><title>Login</title><link rel="stylesheet" href="assets/style.css"></head>
<body style="display:flex;justify-content:center;align-items:center;height:100vh">
<div class="window">
<h2>Rizky Panel Login</h2>
<form method="post">
<input name="username" placeholder="Username" required><br><br>
<input type="password" name="password" placeholder="Password" required><br><br>
<button>Login</button>
</form>
<p style="color:red"><?=$error?></p>
</div></body></html>
EOF

# ----------------------
# DASHBOARD
# ----------------------
cat <<'EOF' > $WEB/dashboard.php
<?php require "security.php"; ?>
<!DOCTYPE html>
<html><head><title>Dashboard</title><link rel="stylesheet" href="assets/style.css"></head>
<body>
<div class="topbar">RIZKY MAULANA — Linux Web Panel</div>
<div class="desktop">
<div class="sidebar">
<h2>Menu</h2>
<a href="dashboard.php">Dashboard</a>
<a href="actions.php?do=restart">Restart Apache</a>
<a href="logs.php">Logs</a>
<a href="filemanager.php">File Manager</a>
<a href="monitor.php">System Monitor</a>
<a href="vhost.php">Virtual Host</a>
<a href="logout.php">Logout</a>
</div>
<div class="main">
<div class="window">
<div class="window-title">Welcome</
