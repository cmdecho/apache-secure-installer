#!/bin/bash

# Nama folder proyek
PROJECT_NAME="rizky_dewa_server"
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

echo "🚀 Membangun RIZKY DEWA SERVER berbasis Docker..."

# 1. Membuat file docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  rizky-app:
    image: php:8.2-apache
    container_name: rizky_dewa_container
    ports:
      - "80:80"
    volumes:
      - ./html:/var/www/html
    restart: always
EOF

# 2. Membuat folder html untuk menyimpan file web
mkdir -p html

# 3. Membuat file login.php (Sesuai kode kamu)
cat <<EOF > html/login.php
<?php
session_start();
\$password_secret = "RIZKY"; 

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
            background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(15px);
            padding: 40px; border-radius: 15px; border: 1px solid rgba(255,255,255,0.2);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3); text-align: center; width: 300px;
        }
        h2 { color: white; margin-bottom: 20px; }
        input { 
            width: 100%; padding: 12px; margin-bottom: 15px; border-radius: 8px; 
            border: none; outline: none; box-sizing: border-box; background: rgba(255,255,255,0.9);
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

# 4. Membuat file logout.php
cat <<EOF > html/logout.php
<?php
session_start();
session_destroy();
header("Location: login.php");
exit;
EOF

# 5. Membuat file index.php (Dashboard Proteksi Session)
cat <<EOF > html/index.php
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
    <style>
        /* CSS SEDERHANA UNTUK DASHBOARD */
        body { margin: 0; font-family: 'Inter', sans-serif; background: #1a1a1a; color: white; display: flex; }
        .sidebar { width: 250px; background: #111; height: 100vh; padding: 20px; border-right: 1px solid #333; }
        .sidebar .brand { font-size: 1.2rem; font-weight: bold; color: #0D8ABC; margin-bottom: 30px; }
        .sidebar a { display: block; color: #ccc; text-decoration: none; padding: 10px 0; }
        .sidebar a.active { color: #0D8ABC; }
        .content { flex: 1; padding: 40px; }
        .status-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .status-card { background: #222; padding: 20px; border-radius: 10px; display: flex; align-items: center; gap: 15px; }
        .text-success { color: #2ecc71; }
        .status-card i { font-size: 2rem; }
    </style>
</head>
<body>
    <nav class="sidebar">
        <div class="brand"><i class="fas fa-server"></i> RIZKY DEWA SERVER</div>
        <a href="#" class="active"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="logout.php" style="color: #ff4d4d;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>
    <main class="content">
        <h1>Welcome, Admin</h1>
        <div class="status-grid">
            <div class="status-card">
                <i class="fas fa-check-circle text-success"></i>
                <div><span>Docker Apache</span><br><small>Status: Active</small></div>
            </div>
            <div class="status-card">
                <i class="fas fa-database" style="color:#3498db"></i>
                <div><span>Database</span><br><small>Status: Connected</small></div>
            </div>
        </div>
        <p style="margin-top: 20px;">Dijalankan di dalam Container Docker (Terisolasi dari OS Linux Mint).</p>
    </main>
</body>
</html>
EOF

# 6. Cek & Install Docker & Docker Compose
if ! command -v docker &> /dev/null; then
    echo "📦 Docker tidak ditemukan. Menginstall..."
    sudo apt update && sudo apt install -y docker.io docker-compose
    sudo usermod -aG docker \$USER
fi

# 7. Jalankan Container
echo "🛠️ Menjalankan Docker Compose..."
sudo docker-compose up -d

echo "------------------------------------------------"
echo "✅ RIZKY DEWA SERVER BERHASIL DI-DEPLOY!"
echo "🔑 Password Login: RIZKY"
echo "🌐 Akses: http://localhost"
echo "📂 Folder Proyek: $(pwd)"
echo "------------------------------------------------"
