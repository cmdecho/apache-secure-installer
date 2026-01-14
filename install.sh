#!/bin/bash

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Menambahkan Fitur Login ke Dashboard..."

# Install PHP (dibutuhkan untuk session & login)
apt update -y && apt install -y apache2 php libapache2-mod-php

# Direktori web
WEB_DIR="/var/www/html"

# 1. Membuat file login.php
cat <<EOF > $WEB_DIR/login.php
<?php
session_start();
\$password_secret = "RIZKY"; // Password yang Anda minta

if (isset(\$_POST['login'])) {
    if (\$_POST['password'] == \$password_secret) {
        \$_SESSION['loggedin'] = true;
        header("Location: index.php");
        exit;
    } else {
        \$error = "Password Salah!";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - RIZKY DEWA SERVER</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body { 
            margin: 0; font-family: 'Inter', sans-serif; 
            background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center center/cover;
            height: 100vh; display: flex; align-items: center; justify-content: center;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.2); backdrop-filter: blur(15px);
            padding: 40px; border-radius: 15px; border: 1px solid rgba(255,255,255,0.3);
            box-shadow: 0 8px 32px rgba(0,0,0,0.2); text-align: center; width: 300px;
        }
        h2 { color: white; margin-bottom: 20px; }
        input { 
            width: 100%; padding: 12px; margin-bottom: 15px; border-radius: 8px; 
            border: none; outline: none; box-sizing: border-box;
        }
        button { 
            width: 100%; padding: 12px; border-radius: 8px; border: none; 
            background: #0D66AB; color: white; font-weight: bold; cursor: pointer;
        }
        .error { color: #ff4d4d; margin-bottom: 10px; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Admin Login</h2>
        <?php if(isset(\$error)) echo "<p class='error'>\$error</p>"; ?>
        <form method="POST">
            <input type="password" name="password" placeholder="Enter Password" required>
            <button type="submit" name="login">LOGIN</button>
        </form>
    </div>
</body>
</html>
EOF

# 2. Membuat file logout.php
cat <<EOF > $WEB_DIR/logout.php
<?php
session_start();
session_destroy();
header("Location: login.php");
exit;
EOF

# 3. Mengubah index.html menjadi index.php (Menambahkan Proteksi Session)
# Perhatikan perubahan pada tombol Logout di dalam sidebar
cat <<EOF > $WEB_DIR/index.php
<?php
session_start();
if (!isset(\$_SESSION['loggedin'])) {
    header("Location: login.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RIZKY DEWA SERVER - Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="background-overlay"></div>
    
    <nav class="sidebar">
        <div class="brand">
            <i class="fas fa-server"></i> RIZKY DEWA SERVER
        </div>
        <div class="menu">
            <a href="#" class="active"><i class="fas fa-th-large"></i> Dashboard</a>
            <a href="logout.php" style="color: #ff4d4d;"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
        <div class="user-info">
            Welcome, <strong>Admin</strong> <img src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" alt="avatar">
        </div>
    </nav>

    <main class="content">
        <div class="status-grid">
            <div class="status-card">
                <i class="fas fa-check-circle text-success"></i>
                <div class="info">
                    <span class="label">Apache Running</span>
                    <span class="sub">Status: Active</span>
                </div>
            </div>
            <div class="status-card">
                <i class="fas fa-lock text-warning"></i>
                <div class="info">
                    <span class="label">SSL Secure</span>
                    <a href="#" class="link">https://example.com</a>
                </div>
            </div>
            <div class="status-card">
                <i class="fas fa-shield-alt text-danger"></i>
                <div class="info">
                    <span class="label">Fail2Ban Active</span>
                    <span class="sub">2 IPs Banned</span>
                </div>
            </div>
            <div class="status-card">
                <i class="fas fa-database text-primary"></i>
                <div class="info">
                    <span class="label">MariaDB Running</span>
                    <span class="sub">Database OK</span>
                </div>
            </div>
        </div>

        <div class="main-grid">
            <div class="glass-card resource-section">
                <h3>Server Resources</h3>
                <div class="chart-container">
                    <div class="circle-chart">
                        <canvas id="cpuChart"></canvas>
                        <span>35%<br><small>CPU</small></span>
                    </div>
                    <div class="circle-chart">
                        <canvas id="memChart"></canvas>
                        <span>62%<br><small>RAM</small></span>
                    </div>
                    <div class="circle-chart">
                        <canvas id="diskChart"></canvas>
                        <span>45%<br><small>Disk</small></span>
                    </div>
                </div>
                <div class="uptime">Uptime: 12d 4h 32m</div>
            </div>

            <div class="glass-card traffic-section">
                <h3>Traffic Overview</h3>
                <canvas id="trafficChart"></canvas>
                <div class="traffic-stats">
                    <div><strong>1,280</strong> Daily Visits</div>
                    <div><strong>3.5 GB</strong> Data Transfer</div>
                </div>
            </div>

            <div class="glass-card db-section">
                <h3>Database Management</h3>
                <div class="btn-group">
                    <button class="btn btn-orange">phpMyAdmin</button>
                    <button class="btn btn-green">Backup Now</button>
                </div>
                <button class="btn btn-blue w-100">Restore Backup</button>
                <div class="db-info">
                    <p>MySQL Info</p>
                    <small>Version: 10.5.12-MariaDB</small><br>
                    <small>Databases: 5</small>
                </div>
            </div>

            <div class="glass-card logs-section">
                <h3>Security Logs</h3>
                <ul class="logs">
                    <li><i class="fas fa-phone-slash"></i> Failed Login: 192.168.1.100 Blocked</li>
                    <li><i class="fas fa-key"></i> SSL Renewal Successful</li>
                    <li><i class="fas fa-ban"></i> IP Banned: 203.0.113.45</li>
                </ul>
            </div>

            <div class="glass-card controls-section">
                <h3>Quick Controls</h3>
                <div class="btn-grid">
                    <button class="btn btn-red"><i class="fas fa-sync"></i> Restart Apache</button>
                    <button class="btn btn-purple"><i class="fas fa-sync"></i> Restart MySQL</button>
                    <button class="btn btn-dark-green"><i class="fas fa-download"></i> System Updates</button>
                    <button class="btn btn-dark-blue"><i class="fas fa-folder"></i> File Manager</button>
                </div>
            </div>
        </div>
    </main>

    <script src="script.js"></script>
</body>
</html>
EOF

# Hapus file lama jika ada
rm -f $WEB_DIR/index.html

# Restart Apache
systemctl restart apache2

echo "------------------------------------------------"
echo "✅ Fitur Login Berhasil Ditambahkan!"
echo "🔑 Password: RIZKY"
echo "🌐 Buka browser dan akses IP server Anda."
echo "------------------------------------------------"
