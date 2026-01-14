#!/bin/bash

# ==================================================
# Apache + PHP Desktop Web Server Panel
# Credit: RIZKY MAULANA
# ==================================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Installing Rizky Desktop Web Panel..."

apt update -y
apt install apache2 php libapache2-mod-php -y

systemctl enable apache2
systemctl start apache2

WEB="/var/www/html/rizky_web"
mkdir -p $WEB/assets

# ======================
# STYLE (DESKTOP UI)
# ======================
cat <<'EOF' > $WEB/assets/style.css
*{box-sizing:border-box;font-family:Inter,Arial}
body{margin:0;background:linear-gradient(135deg,#020617,#0f172a);color:#e5e7eb}
.topbar{height:50px;background:#020617;border-bottom:1px solid #1e293b;
display:flex;align-items:center;padding:0 20px;font-weight:600;color:#38bdf8}
.desktop{display:flex;height:calc(100vh - 50px)}
.sidebar{width:260px;background:#020617;border-right:1px solid #1e293b;padding:20px}
.sidebar h2{margin-bottom:25px}
.sidebar a{display:block;color:#cbd5f5;text-decoration:none;padding:12px;
border-radius:10px;margin-bottom:8px}
.sidebar a:hover{background:#1e293b}
.main{flex:1;padding:30px;overflow:auto}
.window{background:#020617;border:1px solid #1e293b;border-radius:16px;padding:20px;margin-bottom:20px}
.window-title{font-weight:700;color:#38bdf8;margin-bottom:15px}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px}
.card{background:#020617;border:1px solid #1e293b;border-radius:12px;padding:15px}
.footer{text-align:center;color:#64748b;margin-top:40px}
.login{display:flex;justify-content:center;align-items:center;height:100vh}
.login-box{background:#020617;border:1px solid #1e293b;border-radius:16px;
padding:40px;width:360px}
input,button{width:100%;padding:14px;margin-top:14px;border-radius:10px;border:none}
input{background:#020617;color:white;border:1px solid #1e293b}
button{background:#38bdf8;font-weight:700}
.error{color:#fb7185;margin-top:10px}
EOF

# ======================
# CONFIG
# ======================
cat <<'EOF' > $WEB/config.php
<?php
session_start();
define("APP","Rizky Linux Web Panel");
define("USER","admin");
define("PASS", password_hash("RIZKY", PASSWORD_DEFAULT));

ini_set('session.cookie_httponly',1);
ini_set('session.use_strict_mode',1);

if(!isset($_SESSION['csrf'])){
$_SESSION['csrf']=bin2hex(random_bytes(32));
}
?>
EOF

# ======================
# SECURITY
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
# LOGIN
# ======================
cat <<'EOF' > $WEB/login.php
<?php
require "config.php";
$error="";
$_SESSION['try']=$_SESSION['try']??0;
if($_SESSION['try']>5) die("Too many attempts");

if($_SERVER["REQUEST_METHOD"]=="POST"){
if(!hash_equals($_SESSION['csrf'],$_POST['csrf'])) die("CSRF Error");

if($_POST['username']==USER && password_verify($_POST['password'],PASS)){
$_SESSION['login']=true;
$_SESSION['try']=0;
header("Location: dashboard.php");exit;
}else{
$_SESSION['try']++;
$error="Login gagal";
}}
?>
<!DOCTYPE html>
<html>
<head>
<title><?=APP?></title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body class="login">
<div class="login-box">
<h2><?=APP?></h2>
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
$uptime=trim(shell_exec("uptime -p"));
$mem=trim(shell_exec("free -h | awk '/Mem:/ {print $3\" / \"$2}'"));
$disk=round(disk_free_space("/")/disk_total_space("/")*100);
?>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="topbar">RIZKY MAULANA — Linux Desktop Web Panel</div>

<div class="desktop">
<div class="sidebar">
<h2>Rizky Panel</h2>
<a href="#">Dashboard</a>
<a href="#">Server</a>
<a href="#">Security</a>
<a href="logout.php">Logout</a>
</div>

<div class="main">
<div class="window">
<div class="window-title">System Monitor</div>
<div class="grid">
<div class="card">Uptime<br><b><?=$uptime?></b></div>
<div class="card">Memory<br><b><?=$mem?></b></div>
<div class="card">Disk Free<br><b><?=$disk?>%</b></div>
<div class="card">Session<br><b><?=session_id()?></b></div>
</div>
</div>

<div class="window">
<div class="window-title">Server Info</div>
<p>Apache: <?=apache_get_version()?></p>
<p>PHP: <?=phpversion()?></p>
<p>OS: <?=php_uname()?></p>
</div>

<div class="footer">
© <?=date("Y")?> <b>RIZKY MAULANA</b> — Professional Linux Web Panel
</div>
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
echo "======================================"
echo " INSTALL SUCCESS"
echo " http://$IP/rizky_web/login.php"
echo " USER : admin"
echo " PASS : RIZKY"
echo "======================================"
