#!/bin/bash

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Jalankan dengan sudo"
  exit 1
fi

# Menampilkan informasi awal
echo "🚀 Memulai instalasi Web Server Panel dengan Apache, SSL, Fail2Ban..."

# Update sistem dan install paket yang diperlukan
apt update -y
apt upgrade -y
apt install -y apache2 certbot python3-certbot-apache fail2ban unzip curl git

# Mengaktifkan Apache agar berjalan saat boot
systemctl enable apache2
systemctl start apache2

# Mengatur SSL dengan Let's Encrypt
echo "🔒 Mengaktifkan SSL untuk domain example.com..."
certbot --apache -d example.com --non-interactive --agree-tos --email admin@example.com

# Mengatur Fail2Ban untuk melindungi server
echo "🛡️ Mengaktifkan Fail2Ban..."
systemctl enable fail2ban
systemctl start fail2ban

# Menyiapkan direktori web panel
echo "📁 Menyiapkan Web Panel..."

# Direktori untuk website
WEB_DIR="/var/www/html/server_panel"

# Menghapus file default Apache
rm -rf /var/www/html/*

# Menyiapkan file index.html (Dashboard Web Panel)
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>RIZKY DEWA SERVER</title>
  <link rel="stylesheet" href="style.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
  <header>
    <h1>RIZKY DEWA SERVER</h1>
    <p>Welcome, Admin</p>
  </header>

  <div class="dashboard">
    <!-- Server Info -->
    <section id="server-status">
      <div class="status-box">
        <h2>Apache Running</h2>
        <span>Status: Active</span>
      </div>
      <div class="status-box">
        <h2>SSL Secure</h2>
        <span>https://example.com</span>
      </div>
      <div class="status-box">
        <h2>Fail2Ban Active</h2>
        <span>2 IPs Banned</span>
      </div>
    </section>

    <!-- Resource Usage -->
    <section id="server-resources">
      <div class="resource-box">
        <h3>CPU Usage</h3>
        <div class="progress-bar" style="width: 35%;">35%</div>
      </div>
      <div class="resource-box">
        <h3>Memory Usage</h3>
        <div class="progress-bar" style="width: 62%;">62%</div>
      </div>
      <div class="resource-box">
        <h3>Disk Usage</h3>
        <div class="progress-bar" style="width: 45%;">45%</div>
      </div>
    </section>

    <!-- Traffic Overview -->
    <section id="traffic-overview">
      <canvas id="traffic-chart"></canvas>
    </section>

    <!-- Quick Controls -->
    <section id="quick-controls">
      <button onclick="restartApache()">Restart Apache</button>
      <button onclick="fileManager()">File Manager</button>
    </section>
  </div>

  <script src="script.js"></script>
</body>
</html>
EOF

# Menyiapkan file style.css (Desain)
cat <<EOF > /var/www/html/style.css
body {
  font-family: 'Roboto', sans-serif;
  background-color: #f4f7fc;
  color: #333;
  margin: 0;
  padding: 0;
}

header {
  background-color: #005d8e; /* Biru gelap seperti di gambar */
  color: white;
  padding: 20px;
  text-align: center;
  font-size: 1.5em;
}

.dashboard {
  padding: 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  justify-content: space-between;
}

.status-box, .resource-box, .traffic-box {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
  width: 48%;
}

.status-box h2, .resource-box h3 {
  font-size: 1.2em;
}

.progress-bar {
  height: 20px;
  background-color: #4caf50; /* Hijau untuk progress */
  border-radius: 5px;
  text-align: center;
  color: white;
  line-height: 20px;
}

button {
  background-color: #0066cc;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1em;
  margin-top: 10px;
}

button:hover {
  background-color: #005ba0;
}

canvas {
  max-width: 100%;
  height: 300px;
  margin-top: 20px;
}
EOF

# Menyiapkan file script.js (Pengelolaan Grafik dan Kontrol)
cat <<EOF > /var/www/html/script.js
// Menampilkan grafik menggunakan Chart.js
const ctx = document.getElementById('traffic-chart').getContext('2d');
const trafficChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    datasets: [{
      label: 'Visitors',
      data: [1200, 1500, 1300, 1800, 1600, 1400, 1700],
      borderColor: '#4CAF50',
      fill: false,
    },
    {
      label: 'Bandwidth',
      data: [3, 3.5, 3, 4, 3.5, 4, 3],
      borderColor: '#FF6347',
      fill: false,
    }]
  }
});

// Fungsi untuk Restart Apache
function restartApache() {
  fetch('/restart_apache').then(response => {
    alert("Apache Restarted!");
  }).catch(error => {
    alert("Error restarting Apache!");
  });
}

// Fungsi untuk File Manager
function fileManager() {
  window.location.href = "/file_manager";
}
EOF

# Restart Apache untuk menerapkan perubahan
systemctl restart apache2

# Menampilkan status
echo "✅ Instalasi selesai!"
echo "📂 Panel Web dapat diakses di http://example.com"
echo "🔒 SSL sudah terpasang"
echo "🛡️ Fail2Ban telah diaktifkan untuk melindungi server"
