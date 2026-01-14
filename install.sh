#!/bin/bash

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Memulai Instalasi Full Web Panel Premium - RIZKY MAULANA..."

# 1. Update sistem dan install paket yang diperlukan
apt update -y
apt install -y apache2 php libapache2-mod-php certbot python3-certbot-apache fail2ban unzip curl git

# Mengaktifkan Apache dan Fail2Ban
systemctl enable apache2
systemctl start apache2
systemctl enable fail2ban
systemctl start fail2ban

# Direktori web
WEB_DIR="/var/www/html"

# Menghapus file default agar tidak bentrok
rm -f $WEB_DIR/index.html

echo "📁 Menyiapkan file Dashboard dan Sistem Keamanan..."

# 2. Menyiapkan Login Page (login.php)
cat <<EOF > $WEB_DIR/login.php
<?php
session_start();
if(isset(\$_SESSION['logged_in'])) { header('Location: index.php'); exit; }

if(\$_SERVER['REQUEST_METHOD'] == 'POST') {
    \$user = \$_POST['username'];
    \$pass = \$_POST['password'];
    
    if(\$user == 'admin' && \$pass == 'RIZKY') {
        \$_SESSION['logged_in'] = true;
        header('Location: index.php');
        exit;
    } else {
        \$error = "Username atau Password salah!";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - RIZKY MAULANA</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body { margin:0; font-family:'Inter', sans-serif; height:100vh; display:flex; align-items:center; justify-content:center; background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') center/cover; }
        .login-card { background: rgba(255,255,255,0.2); backdrop-filter: blur(15px); padding: 40px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.3); width: 320px; text-align: center; color: white; box-shadow: 0 8px 32px rgba(0,0,0,0.3); }
        h2 { margin-bottom: 5px; font-weight: 600; }
        p.subtitle { font-size: 0.8rem; margin-bottom: 25px; opacity: 0.8; }
        input { width: 100%; padding: 12px; margin: 10px 0; border-radius: 8px; border: none; background: rgba(255,255,255,0.9); box-sizing: border-box; outline: none; color: #333; }
        button { width: 100%; padding: 12px; border-radius: 8px; border: none; background: #0066cc; color: white; cursor: pointer; font-weight: 600; margin-top: 15px; transition: 0.3s; }
        button:hover { background: #0052a3; }
        .error { color: #ff6b6b; font-size: 0.8rem; margin-bottom: 10px; background: rgba(0,0,0,0.2); padding: 5px; border-radius: 5px; }
        .credit { margin-top: 30px; font-size: 0.75rem; opacity: 0.7; letter-spacing: 1px; border-top: 1px solid rgba(255,255,255,0.2); padding-top: 15px; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Login Panel</h2>
        <p class="subtitle">RIZKY MAULANA</p>
        <?php if(isset(\$error)) echo "<div class='error'>\$error</div>"; ?>
        <form method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Sign In</button>
        </form>
        <div class="credit">Created by <strong>RIZKY MAULANA</strong></div>
    </div>
</body>
</html>
EOF

# 3. Menyiapkan API Real-Time (stats.php)
cat <<EOF > $WEB_DIR/stats.php
<?php
header('Content-Type: application/json');
\$cpu = round(sys_getloadavg()[0] * 10, 2);
\$free = shell_exec('free');
\$free_arr = explode("\n", (string)trim(\$free));
\$mem = array_merge(array_filter(explode(" ", \$free_arr[1])));
\$mem_usage = round((\$mem[2] / \$mem[1]) * 100, 2);
\$disk_usage = round(100 - (disk_free_space("/") / disk_total_space("/") * 100), 2);
echo json_encode([
    'cpu' => \$cpu, 
    'ram' => \$mem_usage, 
    'disk' => \$disk_usage, 
    'uptime' => trim(shell_exec('uptime -p'))
]);
EOF

# 4. Menyiapkan Logout (logout.php)
cat <<EOF > $WEB_DIR/logout.php
<?php
session_start();
session_destroy();
header('Location: login.php');
exit;
EOF

# 5. Menyiapkan Dashboard Utama (index.php)
cat <<EOF > $WEB_DIR/index.php
<?php
session_start();
if(!isset(\$_SESSION['logged_in'])) { header('Location: login.php'); exit; }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - RIZKY MAULANA</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="background-overlay"></div>
    <nav class="sidebar">
        <div class="brand"><i class="fas fa-server"></i> RIZKY MAULANA</div>
        <div class="menu">
            <a href="#" class="active"><i class="fas fa-th-large"></i> Dashboard</a>
            <a href="logout.php" style="color:#ff6b6b;"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
        <div class="user-info">Admin <img src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" alt="avatar"></div>
    </nav>
    <main class="content">
        <div class="status-grid">
            <div class="status-card"><i class="fas fa-check-circle text-success"></i><div class="info"><span>Apache</span><br><small>Running</small></div></div>
            <div class="status-card"><i class="fas fa-shield-alt text-danger"></i><div class="info"><span>Fail2Ban</span><br><small>Active</small></div></div>
            <div class="status-card"><i class="fas fa-database text-primary"></i><div class="info"><span>Database</span><br><small>Healthy</small></div></div>
        </div>
        <div class="main-grid">
            <div class="glass-card">
                <h3>Server Resources</h3>
                <div class="chart-container">
                    <div class="circle-chart"><canvas id="cpuChart"></canvas><span id="cpuText">0%</span></div>
                    <div class="circle-chart"><canvas id="memChart"></canvas><span id="memText">0%</span></div>
                    <div class="circle-chart"><canvas id="diskChart"></canvas><span id="diskText">0%</span></div>
                </div>
                <div id="uptimeText" style="margin-top:15px; font-size:0.8rem; opacity:0.7;">Loading uptime...</div>
            </div>
            <div class="glass-card">
                <h3>Quick Controls</h3>
                <div class="btn-grid">
                    <button class="btn btn-red">Restart Apache</button>
                    <button class="btn btn-dark-blue">File Manager</button>
                </div>
                <div style="margin-top: 20px; font-size: 0.7rem; opacity: 0.5; text-align: center;">
                    © RIZKY MAULANA - 2026
                </div>
            </div>
        </div>
    </main>
    <script src="script.js"></script>
</body>
</html>
EOF

# 6. Menyiapkan CSS (style.css)
cat <<EOF > $WEB_DIR/style.css
:root { --glass: rgba(255, 255, 255, 0.7); --border: rgba(255, 255, 255, 0.3); }
body { margin: 0; font-family: 'Inter', sans-serif; color: #333; height: 100vh; }
.background-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center center/cover; z-index: -1; }
.sidebar { background: rgba(13, 102, 171, 0.85); backdrop-filter: blur(10px); color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
.brand { font-weight: 600; }
.menu a { color: rgba(255,255,255,0.8); text-decoration: none; margin: 0 15px; font-size: 0.9rem; }
.content { padding: 25px; }
.status-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 25px; }
.status-card { background: var(--glass); backdrop-filter: blur(10px); border: 1px solid var(--border); padding: 15px; border-radius: 12px; display: flex; align-items: center; gap: 15px; }
.main-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; }
.glass-card { background: var(--glass); backdrop-filter: blur(15px); border: 1px solid var(--border); border-radius: 15px; padding: 20px; }
.chart-container { display: flex; justify-content: space-around; text-align: center; }
.circle-chart { position: relative; width: 80px; height: 80px; }
.circle-chart span { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 0.7rem; font-weight: bold; }
.btn { border: none; padding: 10px; border-radius: 6px; color: white; cursor: pointer; width: 100%; margin-bottom: 10px; }
.btn-red { background: #c0392b; }
.btn-dark-blue { background: #2c3e50; }
.text-success { color: #2ecc71; }
.text-danger { color: #e74c3c; }
.text-primary { color: #3498db; }
EOF

# 7. Menyiapkan JavaScript (script.js)
cat <<EOF > $WEB_DIR/script.js
let charts = {};
function createDonut(id, color) {
    charts[id] = new Chart(document.getElementById(id), {
        type: 'doughnut',
        data: { datasets: [{ data: [0, 100], backgroundColor: [color, 'rgba(0,0,0,0.05)'], borderWidth: 0 }] },
        options: { cutout: '80%', plugins: { tooltip: { enabled: false } } }
    });
}
createDonut('cpuChart', '#3498db');
createDonut('memChart', '#2ecc71');
createDonut('diskChart', '#e74c3c');

function updateStats() {
    fetch('stats.php').then(r => r.json()).then(data => {
        document.getElementById('cpuText').innerHTML = data.cpu + '%<br>CPU';
        document.getElementById('memText').innerHTML = data.ram + '%<br>RAM';
        document.getElementById('diskText').innerHTML = data.disk + '%<br>Disk';
        document.getElementById('uptimeText').innerText = 'Uptime: ' + data.uptime;
        charts['cpuChart'].data.datasets[0].data = [data.cpu, 100-data.cpu];
        charts['memChart'].data.datasets[0].data = [data.ram, 100-data.ram];
        charts['diskChart'].data.datasets[0].data = [data.disk, 100-data.disk];
        Object.values(charts).forEach(c => c.update());
    });
}
setInterval(updateStats, 3000); updateStats();
EOF

# Restart Apache
systemctl restart apache2

echo "------------------------------------------------"
echo "✅ INSTALASI SELESAI"
echo "🌐 Akses Panel: http://localhost atau http://ip-server"
echo "🔑 Login: admin / RIZKY"
echo "👤 Owner: RIZKY MAULANA"
echo "------------------------------------------------"
