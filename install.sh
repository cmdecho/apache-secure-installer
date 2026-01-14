#!/bin/bash

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Memperbarui Dashboard ke Desain Premium..."

# Update sistem dan install paket
apt update -y && apt install -y apache2 php libapache2-mod-php

# Direktori web
WEB_DIR="/var/www/html"

# Menyiapkan file login.html
cat <<EOF > $WEB_DIR/login.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - RIZKY DEWA SERVER</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h2>Login</h2>
            <form action="login.php" method="POST">
                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" name="username" id="username" required>
                </div>
                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password" required>
                </div>
                <button type="submit" class="btn btn-green">Login</button>
            </form>
        </div>
    </div>
</body>
</html>
EOF

# Menyiapkan file login.php
cat <<EOF > $WEB_DIR/login.php
<?php
session_start();

// Cek jika sudah login, langsung redirect ke dashboard
if (isset(\$_SESSION['logged_in'])) {
    header("Location: index.html");
    exit;
}

// Cek jika form login disubmit
if (\$_SERVER['REQUEST_METHOD'] == 'POST') {
    \$username = \$_POST['username'];
    \$password = \$_POST['password'];

    // Cek kredensial (ganti dengan database atau metode autentikasi lain)
    if (\$username == 'admin' && \$password == 'adminpassword') {
        \$_SESSION['logged_in'] = true;
        header("Location: index.html");
        exit;
    } else {
        echo "<script>alert('Username atau Password salah!');</script>";
    }
}
?>
EOF

# Menyiapkan file logout.php
cat <<EOF > $WEB_DIR/logout.php
<?php
session_start();
session_destroy(); // Hapus session login
header("Location: login.html"); // Arahkan ke halaman login
exit;
?>
EOF

# Menyiapkan file index.html (Dashboard)
cat <<EOF > $WEB_DIR/index.html
<?php
session_start();
if (!isset(\$_SESSION['logged_in'])) {
    header("Location: login.html");
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
            <a href="#"><i class="fas fa-database"></i> Database</a>
            <a href="#"><i class="fas fa-cog"></i> Settings</a>
            <a href="logout.php"><i class="fas fa-sign-out-alt"></i> Logout</a>
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
