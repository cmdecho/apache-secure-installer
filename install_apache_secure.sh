#!/bin/bash
# ==================================================
# Rizky Linux Web Panel + Web Terminal + Dashboard
# Credit: RIZKY MAULANA
# Debian / Ubuntu / Linux Mint
# ==================================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Installing Rizky Linux Web Panel..."

# Install Apache, PHP, and tools
apt update -y
apt install -y apache2 php libapache2-mod-php sudo

# Enable Apache and start it
systemctl enable apache2
systemctl start apache2

# Enable Port 80 in UFW (Firewall)
ufw allow 80/tcp
ufw reload

WEB="/var/www/html/rizky_web"
mkdir -p $WEB/assets

# ======================
# STYLE (DESKTOP UI)
# ======================
cat <<'EOF' > $WEB/assets/style.css
*{box-sizing:border-box;font-family:Inter,Arial}
body{margin:0;background:linear-gradient(135deg,#020617,#0f172a);color:#e5e7eb;display:flex;min-height:100vh}
.sidebar{width:240px;background:#020617;border-right:1px solid #1e293b;padding:20px}
.sidebar h2{color:#38bdf8;margin-bottom:30px}
.sidebar a{display:block;color:#cbd5f5;text-decoration:none;padding:12px;border-radius:8px;margin:6px 0}
.sidebar a:hover{background:#1e293b}
.main{flex:1;padding:30px}
.card{background:#020617;border:1px solid #1e293b;border-radius:12px;padding:20px}
input,button,textarea{width:100%;padding:12px;margin-top:10px;background:#020617;color:#e5e7eb;border:1px solid #1e293b;border-radius:8px}
button{background:#38bdf8;color:#020617;font-weight:bold}
pre{background:#020617;border:1px solid #1e293b;padding:15px;border-radius:10px;overflow:auto}
EOF

# ======================
# CONFIG
# ======================
cat <<'EOF' > $WEB/config.php
<?php
session_start();
define("APP_NAME","Rizky Linux Web Panel");
define("USERNAME","admin");
define("PASSWORD_HASH", password_hash("RIZKY", PASSWORD_DEFAULT));
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
if($_SERVER["REQUEST_METHOD"]==="POST"){
if(!hash_equals($_SESSION['csrf'],$_POST['csrf'])) die("CSRF ERROR");
if($_POST['username']===USERNAME && password_verify($_POST['password'],PASSWORD_HASH)){
$_SESSION['login']=true;
header("Location: dashboard.php");exit;
}else{$error="Login gagal";}
}
?>
<!DOCTYPE html>
<html><head><title>Login</title>
<link rel="stylesheet" href="assets/style.css"></head>
<body style="display:flex;justify-content:center;align-items:center">
<div class="card" style="max-width:400px">
<h2>🔐 Login Panel</h2>
<form method="post">
<input type="hidden" name="csrf" value="<?=$_SESSION['csrf']?>">
<input name="username" placeholder="Username" required>
<input type="password" name="password" placeholder="Password" required>
<button>Login</button>
</form>
<div style="color:#fb7185"><?=$error?></div>
</div></body></html>
EOF

# ======================
# DASHBOARD (COMPLETE)
# ======================
cat <<'EOF' > $WEB/dashboard.php
<?php require "security.php"; ?>
<!DOCTYPE html>
<html><head><title>Web Server Dashboard</title>
<link rel="stylesheet" href="assets/style.css"></head>
<body>
<div class="sidebar">
<h2>Rizky Panel</h2>
<a href="dashboard.php">Dashboard</a>
<a href="terminal.php">Web Terminal</a>
<a href="filemanager.php">File Manager</a>
<a href="logout.php">Logout</a>
</div>

<div class="main">
<h1>🖥 Web Server Dashboard</h1>

<!-- System Monitor -->
<div class="card">
<h3>System Monitor</h3>
<p><b>Uptime:</b> <?=shell_exec("uptime -p")?></p>
<p><b>Memory Usage:</b> <?=trim(shell_exec("free -h | awk '/Mem:/ {print $3 \" / \" $2}'"))?></p>
<p><b>Disk Usage:</b> <?=trim(shell_exec("df -h | awk '$NF==\"/\"{print $5}'"))?></p>
<p><b>CPU Load:</b> <?=implode(" / ",sys_getloadavg())?></p>
</div>

<!-- Server Information -->
<div class="card">
<h3>Server Information</h3>
<p><b>Apache:</b> <?=apache_get_version()?></p>
<p><b>PHP:</b> <?=phpversion()?></p>
<p><b>OS:</b> <?=php_uname()?></p>
</div>

<!-- Quick Actions -->
<div class="card">
<h3>Quick Actions</h3>
<form method="post" action="actions.php">
<button name="action" value="restart">🔄 Restart Apache</button>
<button name="action" value="logs">📜 View Logs</button>
<button name="action" value="users">👤 Manage Users</button>
</form>
</div>

<!-- Network Info -->
<div class="card">
<h3>Network Info</h3>
<p><b>IP Address:</b> <?= $_SERVER['SERVER_ADDR'] ?></p>
<p><b>Session ID:</b> <?= session_id() ?></p>
</div>

<div class="footer">
© <?=date("Y")?> <b>RIZKY MAULANA</b> — Professional Linux Web Panel
</div>

</div>
</body></html>
EOF

# ======================
# TERMINAL WEB (SAFE)
# ======================
cat <<'EOF' > $WEB/terminal.php
<?php
require "security.php";
$output="";
$allowed=["ls","pwd","whoami","uptime","df","free","ip a","cat","tail","head"];
if(isset($_POST['cmd'])){
$cmd=trim($_POST['cmd']);
foreach($allowed as $a){
if(str_starts_with($cmd,$a)){
$output=shell_exec("cd /var/www && $cmd 2>&1");
break;
}}
if(!$output)$output="Command not allowed";
}
?>
<!DOCTYPE html>
<html><head><title>Terminal</title>
<link rel="stylesheet" href="assets/style.css"></head>
<body>
<div class="sidebar">
<h2>Rizky Panel</h2>
<a href="dashboard.php">Dashboard</a>
<a href="terminal.php">Web Terminal</a>
<a href="logout.php">Logout</a>
</div>
<div class="main">
<h1>🖥 Web Terminal</h1>
<form method="post">
<input name="cmd" placeholder="contoh: ls /var/www">
<button>Run</button>
</form>
<pre><?=$output?></pre>
</div></body></html>
EOF

# ======================
# LOGOUT
# ======================
cat <<'EOF' > $WEB/logout.php
<?php session_destroy();header("Location: login.php"); ?>
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
