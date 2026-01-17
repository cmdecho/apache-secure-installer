#!/bin/bash

# Konfigurasi Nama Proyek
PROJECT_NAME="rizky_dewa_server"
mkdir -p $PROJECT_NAME/html
cd $PROJECT_NAME

echo "💎 MENGINSTALL RIZKY DEWA: GLASSMORPHISM ULTIMATE EDITION..."

# 1. MEMBUAT DOCKER COMPOSE
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

# 2. MEMBUAT HALAMAN LOGIN (GLASSMORPHISM)
cat <<EOF > html/login.php
<?php
session_start();
if (isset(\$_POST['login'])) {
    if (\$_POST['password'] == "RIZKY") {
        \$_SESSION['loggedin'] = true;
        header("Location: index.php"); exit;
    } else { \$error = "Akses Ditolak!"; }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Secure Login | RIZKY DEWA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { 
            background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center center fixed;
            background-size: cover; height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 30px;
            padding: 50px; width: 400px; text-align: center;
            box-shadow: 0 25px 50px rgba(0,0,0,0.3);
        }
        input { 
            background: rgba(255, 255, 255, 0.1) !important; 
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
            color: white !important; border-radius: 12px !important;
            text-align: center; margin-bottom: 20px;
        }
        .btn-glass {
            background: #0070f3; color: white; border: none;
            width: 100%; padding: 12px; border-radius: 12px; font-weight: bold;
            transition: 0.3s;
        }
        .btn-glass:hover { background: #0056b3; transform: scale(1.05); }
    </style>
</head>
<body>
    <div class="login-card">
        <h2 class="text-white fw-bold mb-4">RIZKY DEWA</h2>
        <?php if(isset(\$error)) echo "<p class='text-danger'>\$error</p>"; ?>
        <form method="POST">
            <input type="password" name="password" class="form-control" placeholder="Enter Access Key" required>
            <button type="submit" name="login" class="btn-glass">UNLOCK SERVER</button>
        </form>
    </div>
</body>
</html>
EOF

# 3. MEMBUAT DASHBOARD UTAMA (GLASSMORPHISM + REMOTE CONSOLE)
cat <<EOF > html/index.php
<?php
session_start();
if (!isset(\$_SESSION['loggedin'])) { header("Location: login.php"); exit; }

\$cmd_output = "";
if (isset(\$_POST['exec_cmd'])) {
    \$cmd = \$_POST['command'];
    \$allowed_cmds = ['ls', 'whoami', 'pwd', 'date', 'uptime', 'free', 'hostname'];
    \$base_cmd = explode(' ', trim(\$cmd))[0];
    if (in_array(\$base_cmd, \$allowed_cmds)) {
        \$cmd_output = shell_exec(\$cmd . " 2>&1");
    } else {
        \$cmd_output = "Akses Ditolak: Perintah '\$base_cmd' tidak diizinkan.";
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | RIZKY DEWA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap');
        
        body { 
            background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center center fixed;
            background-size: cover; color: #fff; font-family: 'Plus Jakarta Sans', sans-serif; min-height: 100vh;
        }

        .sidebar { 
            width: 280px; height: 100vh; background: rgba(255, 255, 255, 0.1); 
            backdrop-filter: blur(20px); position: fixed; padding: 30px; 
            border-right: 1px solid rgba(255, 255, 255, 0.2); 
        }

        .main-content { margin-left: 280px; padding: 50px; }

        .glass-card { 
            background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(25px); 
            border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 20px; padding: 30px; 
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
        }

        .terminal-window {
            background: rgba(0, 0, 0, 0.7); border-radius: 15px; 
            overflow: hidden; border: 1px solid rgba(0, 112, 243, 0.4);
        }

        .terminal-header {
            background: rgba(255, 255, 255, 0.1); padding: 12px 20px; 
            display: flex; align-items: center; gap: 8px;
        }

        .dot { width: 12px; height: 12px; border-radius: 50%; }
        .red { background: #ff5f56; } .yellow { background: #ffbd2e; } .green { background: #27c93f; }

        .terminal-body {
            padding: 25px; font-family: 'Courier New', monospace;
            color: #00ffcc; height: 350px; overflow-y: auto;
        }

        .cmd-input {
            background: transparent; border: none; color: #fff; width: 100%; 
            outline: none; font-family: 'Courier New', monospace; caret-color: #00ffcc;
        }

        .nav-item {
            padding: 12px 20px; border-radius: 12px; color: rgba(255,255,255,0.7);
            text-decoration: none; display: flex; align-items: center; margin-bottom: 10px;
        }

        .nav-item.active, .nav-item:hover { background: rgba(255, 255, 255, 0.2); color: #fff; }

        .status-badge {
            background: rgba(0, 255, 150, 0.2); border: 1px solid rgba(0, 255, 150, 0.5);
            padding: 5px 15px; border-radius: 50px; font-size: 12px; color: #00ff96;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="mb-5 d-flex align-items-center">
            <i class="fas fa-microchip fa-2x me-3 text-info"></i>
            <span class="h4 mb-0 fw-bold">RIZKY DEWA</span>
        </div>
        <a href="#" class="nav-item active"><i class="fas fa-terminal me-3"></i> Commander</a>
        <a href="#" class="nav-item"><i class="fas fa-server me-3"></i> Containers</a>
        <a href="logout.php" class="nav-item text-danger mt-5"><i class="fas fa-power-off me-3"></i> Terminate</a>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h1 class="fw-bold">Cloud Terminal</h1>
            <div class="status-badge">● SYSTEM ONLINE</div>
        </div>

        <div class="glass-card mb-4">
            <div class="terminal-window">
                <div class="terminal-header">
                    <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                    <span class="ms-2 small opacity-50">root@rizky-dewa-server:~</span>
                </div>
                <div class="terminal-body" id="term-body">
                    <?php if (\$cmd_output): ?>
                        <pre style="white-space: pre-wrap;"><?php echo htmlspecialchars(\$cmd_output); ?></pre>
                    <?php else: ?>
                        <div class="opacity-50">Ready... Ketik perintah (ls, uptime, date)</div>
                    <?php endif; ?>
                    
                    <div class="d-flex align-items-center mt-2">
                        <span class="text-info me-2 fw-bold">rizky#</span>
                        <form method="POST" class="w-100">
                            <input type="text" name="command" class="cmd-input" autofocus autocomplete="off">
                            <input type="submit" name="exec_cmd" style="display: none;">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        const body = document.getElementById('term-body');
        body.scrollTop = body.scrollHeight;
    </script>
</body>
</html>
EOF

# 4. MEMBUAT HALAMAN LOGOUT
echo "<?php session_start(); session_destroy(); header('Location: login.php'); ?>" > html/logout.php

# 5. MENJALANKAN DOCKER
echo "🚀 Menyinkronkan Container Glassmorphism..."
sudo docker-compose up -d

echo "------------------------------------------------"
echo "✅ INSTALASI SELESAI!"
echo "🌐 Akses: http://localhost"
echo "🔑 Password: RIZKY"
echo "------------------------------------------------"
