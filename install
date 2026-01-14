#!/bin/bash

# ==================================================
# Apache + PHP + Secure Web Server Dashboard
# Admin Panel Installer
# Credit: RIZKY MAULANA
# ==================================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Installing Apache Web Panel..."

apt update -y
apt install apache2 php libapache2-mod-php libapache2-mod-wsgi-py3 -y

systemctl enable apache2
systemctl start apache2

WEB="/var/www/html/rizky_web"
mkdir -p $WEB/assets

# ======================
# STYLE (ADMIN UI)
# ======================
cat <<'EOF' > $WEB/assets/style.css
*{box-sizing:border-box;font-family:Inter,Arial}
body{margin:0;background:#020617;color:#e5e7eb;display:flex;min-height:100vh}
.sidebar{width:240px;background:#020617;border-right:1px solid #1e293b;padding:20px}
.sidebar h2{color:#38bdf8;margin-bottom:30px}
.sidebar a{display:block;color:#cbd5f5;text-decoration:none;padding:12px;border-radius:8px;margin-bottom:8px}
.sidebar a:hover{background:#1e293b}
.main{flex:1;padding:30px}
.topbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:30px}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px}
.card{background:#020617;border:1px solid #1e293b;border-radius:14px;padding:20px}
.footer{margin-top:40px;color:#64748b;text-align:center;font-size:14px}
.status-ok{color:#22c55e}
.login-box{background:#020617;border:1px solid #1e293b;border-radius:14px;padding:30px;width:100%;max-width:400px}
input,button{width:100%;padding:14px;margin-top:12px;border-radius:10px;border:none}
input{background:#020617;color:white;border:1px solid #1e293b}
button{background:#38bdf8;font-weight:700}
.error{color:#fb7185}
EOF

# ======================
# CONFIG
# ======================
cat <<'EOF' > $WEB/config.php
<?php
session_start();

define("APP_NAME","Rizky Web Server Panel");
define("USERNAME","admin");
define("PASSWORD_HASH", password_hash("Rizky@2025", PASSWORD_DEFAULT));

ini_set('session.cookie_httponly',1);
ini_set('session.use_strict_mode',1);

if (!isset($_SESSION['csrf'])) {
    $_SESSION['csrf'] = bin2hex(random_bytes(32));
}
?>
EOF

# ======================
# SECURITY
# ======================
cat <<'EOF' > $WEB/security.php
<?php
require "config.php";
if (!isset($_SESSION['login'])) {
    header("Location: login.php");
    exit;
}
?>
EOF

# ======================
# LOGIN
# ======================
cat <<'EOF' > $WEB/login.php
<?php
require "config.php";

$error="";
$_SESSION['attempts']=$_SESSION['attempts']??0;
if ($_SESSION['attempts']>5) die("Too many attempts");

if ($_SERVER["REQUEST_METHOD"]==="POST"){
if(!hash_equals($_SESSION['csrf'],$_POST['csrf'])) die("CSRF Error");

if($_POST['username']===USERNAME && password_verify($_POST['password'],PASSWORD_HASH)){
$_SESSION['login']=true;
$_SESSION['attempts']=0;
header("Location: dashboard.php");exit;
}else{
$_SESSION['attempts']++;
$error="Login gagal";
}}
?>
<!DOCTYPE html>
<html>
<head>
<title><?=APP_NAME?></title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body style="display:flex;justify-content:center;align-items:center">
<div class="login-box">
<h2>Login Panel</h2>
<form method="post">
<input type="hidden" name="csrf" value="<?=$_SESSION['csrf']?>">
<input name="username" placeholder="Username" required>
<input type="password" name="password" placeholder="Password" required>
<button>Login</button>
</form>
<div class="error"><?=$error?></div>
</div>
</body>
</html>
EOF

# ======================
# DASHBOARD
# ======================
cat <<'EOF' > $WEB/dashboard.php
<?php
require "security.php";
$apache=apache_get_version();
$php=phpversion();
$os=php_uname();
$ip=$_SERVER['SERVER_ADDR'];
$uptime=trim(shell_exec("uptime -p"));
$disk=round(disk_free_space("/")/disk_total_space("/")*100);
$memory=trim(shell_exec("free -h | awk '/Mem:/ {print $3\" / \"$2}'"));
?>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="sidebar">
<h2>Rizky Panel</h2>
<a href="#">Dashboard</a>
<a href="#">Server Info</a>
<a href="#">Security</a>
<a href="logout.php">Logout</a>
</div>
<div class="main">
<div class="topbar">
<h1>Web Server Dashboard</h1>
<span class="status-ok">● Server Online</span>
</div>
<div class="cards">
<div class="card"><h3>Apache</h3><p><?=$apache?></p></div>
<div class="card"><h3>PHP</h3><p><?=$php?></p></div>
<div class="card"><h3>OS</h3><p><?=$os?></p></div>
<div class="card"><h3>Server IP</h3><p><?=$ip?></p></div>
<div class="card"><h3>Uptime</h3><p><?=$uptime?></p></div>
<div class="card"><h3>Disk Free</h3><p><?=$disk?>%</p></div>
<div class="card"><h3>Memory</h3><p><?=$memory?></p></div>
<div class="card"><h3>Session</h3><p><?=session_id()?></p></div>
</div>
<div class="footer">
© <?=date("Y")?> <b>RIZKY MAULANA</b> — Web Server Panel
</div>
</div>
</body>
</html>
EOF

# ======================
# LOGOUT
# ======================
cat <<'EOF' > $WEB/logout.php
<?php
session_start();
session_destroy();
header("Location: login.php");
exit;
?>
EOF

chown -R www-data:www-data $WEB
chmod -R 755 $WEB
systemctl restart apache2

IP=$(hostname -I | awk '{print $1}')
echo "===================================="
echo " INSTALL SUCCESS"
echo " http://$IP/rizky_web/login.php"
echo " USER : admin"
echo " PASS : Rizky@2025"
echo "===================================="
