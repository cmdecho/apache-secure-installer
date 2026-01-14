#!/bin/bash

# =====================================
# Apache + PHP + Secure Login Dashboard
# Advanced Version
# By Rizky
# =====================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

apt update -y
apt install apache2 php libapache2-mod-php libapache2-mod-wsgi-py3 -y

systemctl enable apache2
systemctl start apache2

WEB="/var/www/html/rizky_web"
mkdir -p $WEB/assets

# ======================
# STYLE (UI MODERN)
# ======================
cat <<'EOF' > $WEB/assets/style.css
*{box-sizing:border-box;font-family:Inter,Arial}
body{
margin:0;
min-height:100vh;
background:linear-gradient(135deg,#020617,#020617,#0f172a);
color:#e5e7eb;
display:flex;
justify-content:center;
align-items:center
}
.card{
background:rgba(30,41,59,.7);
backdrop-filter:blur(20px);
padding:40px;
border-radius:16px;
width:100%;
max-width:420px;
box-shadow:0 20px 40px rgba(0,0,0,.5)
}
h1{margin-bottom:20px}
input,button{
width:100%;
padding:14px;
margin-top:12px;
border-radius:10px;
border:none;
outline:none
}
input{background:#020617;color:#fff}
button{
background:linear-gradient(135deg,#38bdf8,#0ea5e9);
font-weight:700;
cursor:pointer
}
.error{color:#fb7185;margin-top:10px}
.topbar{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:20px
}
a{color:#38bdf8;text-decoration:none;font-weight:600}
EOF

# ======================
# CONFIG
# ======================
cat <<'EOF' > $WEB/config.php
<?php
session_start();

/* USER CONFIG */
define("APP_NAME","Rizky Secure Panel");
define("USERNAME","admin");
define("PASSWORD_HASH", password_hash("Rizky@2025", PASSWORD_DEFAULT));

/* SECURITY */
ini_set('session.cookie_httponly',1);
ini_set('session.use_strict_mode',1);

if (!isset($_SESSION['csrf'])) {
    $_SESSION['csrf'] = bin2hex(random_bytes(32));
}
?>
EOF

# ======================
# SECURITY MIDDLEWARE
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

$error = "";
$_SESSION['attempts'] = $_SESSION['attempts'] ?? 0;

if ($_SESSION['attempts'] > 5) {
    die("Terlalu banyak percobaan login.");
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (!hash_equals($_SESSION['csrf'], $_POST['csrf'])) {
        die("CSRF detected");
    }

    if ($_POST['username'] === USERNAME && password_verify($_POST['password'], PASSWORD_HASH)) {
        $_SESSION['login'] = true;
        $_SESSION['attempts'] = 0;
        header("Location: dashboard.php");
        exit;
    } else {
        $_SESSION['attempts']++;
        $error = "Login gagal";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
<title><?=APP_NAME?></title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="card">
<h1>Login Panel</h1>
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
<?php require "security.php"; ?>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="card">
<div class="topbar">
<h2><?=APP_NAME?></h2>
<a href="logout.php">Logout</a>
</div>
<p>Selamat datang, Admin.</p>
<p>Status: <b>Authenticated</b></p>
<p>Session ID: <?=session_id()?></p>
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
echo "=================================="
echo " LOGIN READY"
echo " http://$IP/rizky_web/login.php"
echo " USER : admin"
echo " PASS : Rizky@2025"
echo "=================================="
