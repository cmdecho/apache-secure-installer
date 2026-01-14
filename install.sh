#!/bin/bash

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

echo "🚀 Memperbarui Dashboard ke Desain Premium..."

# Update sistem dan install paket
apt update -y && apt install -y apache2

# Direktori web
WEB_DIR="/var/www/html"

# Menyiapkan file index.html (Dashboard Modern)
cat <<EOF > $WEB_DIR/index.html
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

# Menyiapkan file style.css (Efek Glassmorphism)
cat <<EOF > $WEB_DIR/style.css
:root {
    --glass: rgba(255, 255, 255, 0.7);
    --border: rgba(255, 255, 255, 0.3);
}

body {
    margin: 0;
    font-family: 'Inter', sans-serif;
    color: #333;
    overflow-x: hidden;
    height: 100vh;
}

.background-overlay {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center center/cover;
    z-index: -1;
}

/* Sidebar */
.sidebar {
    background: rgba(13, 102, 171, 0.85);
    backdrop-filter: blur(10px);
    color: white;
    padding: 15px 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

.brand { font-weight: 600; font-size: 1.2rem; }
.menu a { color: rgba(255,255,255,0.8); text-decoration: none; margin: 0 15px; font-size: 0.9rem; }
.menu a.active { color: #fff; border-bottom: 2px solid #fff; padding-bottom: 5px; }
.user-info img { width: 35px; border-radius: 50%; vertical-align: middle; margin-left: 10px; }

/* Main Layout */
.content { padding: 25px; }

.status-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
    margin-bottom: 25px;
}

.status-card {
    background: var(--glass);
    backdrop-filter: blur(10px);
    border: 1px solid var(--border);
    padding: 15px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    gap: 15px;
}

.status-card i { font-size: 2rem; }

/* Glass Cards */
.main-grid {
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr;
    gap: 20px;
}

.glass-card {
    background: var(--glass);
    backdrop-filter: blur(15px);
    border: 1px solid var(--border);
    border-radius: 15px;
    padding: 20px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.glass-card h3 { font-size: 1rem; margin-top: 0; margin-bottom: 20px; color: #444; }

/* Charts Area */
.chart-container { display: flex; justify-content: space-around; text-align: center; }
.circle-chart { position: relative; width: 80px; height: 80px; }
.circle-chart span { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 0.8rem; font-weight: bold; }

/* Buttons */
.btn { border: none; padding: 10px 15px; border-radius: 6px; color: white; cursor: pointer; font-weight: 600; margin-bottom: 10px; }
.btn-orange { background: #e67e22; }
.btn-green { background: #27ae60; }
.btn-blue { background: #2980b9; }
.btn-red { background: #c0392b; }
.btn-purple { background: #8e44ad; }
.btn-dark-green { background: #16a085; }
.btn-dark-blue { background: #2c3e50; }
.w-100 { width: 100%; }

.btn-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }

/* Logs */
.logs { list-style: none; padding: 0; font-size: 0.85rem; }
.logs li { padding: 8px 0; border-bottom: 1px solid rgba(0,0,0,0.05); }

.text-success { color: #2ecc71; }
.text-warning { color: #f1c40f; }
.text-danger { color: #e74c3c; }
.text-primary { color: #3498db; }
EOF

# Menyiapkan file script.js (Chart logic)
cat <<EOF > $WEB_DIR/script.js
function createDonut(id, color, value) {
    new Chart(document.getElementById(id), {
        type: 'doughnut',
        data: {
            datasets: [{
                data: [value, 100 - value],
                backgroundColor: [color, '#eee'],
                borderWidth: 0
            }]
        },
        options: { cutout: '80%', plugins: { tooltip: { enabled: false } } }
    });
}

createDonut('cpuChart', '#3498db', 35);
createDonut('memChart', '#2ecc71', 62);
createDonut('diskChart', '#e74c3c', 45);

const ctx = document.getElementById('trafficChart').getContext('2d');
new Chart(ctx, {
    type: 'line',
    data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
            label: 'Visitors',
            data: [1000, 1500, 1200, 2100, 1800, 2400, 2200],
            borderColor: '#3498db',
            backgroundColor: 'rgba(52, 152, 219, 0.2)',
            fill: true,
            tension: 0.4
        }]
    },
    options: { plugins: { legend: { display: false } } }
});
EOF

systemctl restart apache2
echo "✅ Dashboard Selesai! Silakan refresh browser Anda."
