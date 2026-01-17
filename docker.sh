#!/bin/bash

# Konfigurasi Nama Proyek
PROJECT_NAME="rizky_dewa_server"
mkdir -p $PROJECT_NAME/html
cd $PROJECT_NAME

echo "✨ MENGINSTALL RIZKY DEWA: ZENITH ULTRA EDITION..."

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

# 2. MEMBUAT HALAMAN LOGIN (ULTRA GLASS)
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
    <title>Zenith Login | RIZKY DEWA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700&display=swap');
        body { 
            background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center center fixed;
            background-size: cover; height: 100vh; display: flex; align-items: center; justify-content: center;
            font-family: 'Plus Jakarta Sans', sans-serif; color: white; margin: 0;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(30px);
            border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 40px;
            padding: 60px; width: 450px; text-align: center;
            box-shadow: 0 40px 100px rgba(0,0,0,0.5);
            animation: cardAppear 1s ease-out;
        }
        @keyframes cardAppear { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }
        input { 
            background: rgba(255, 255, 255, 0.1) !important; border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: white !important; border-radius: 15px !important; padding: 15px !important;
            text-align: center; margin-bottom: 25px; transition: 0.3s;
        }
        input:focus { box-shadow: 0 0 20px rgba(0, 112, 243, 0.5) !important; border-color: #0070f3 !important; }
        .btn-zenith {
            background: linear-gradient(135deg, #0070f3, #00c6ff); color: white; border: none;
            width: 100%; padding: 15px; border-radius: 15px; font-weight: 700;
            letter-spacing: 1px; transition: 0.3s; box-shadow: 0 10px 20px rgba(0, 112, 243, 0.3);
        }
        .btn-zenith:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(0, 112, 243, 0.5); }
    </style>
</head>
<body>
    <div class="login-card">
        <h1 class="fw-bold mb-2">ZENITH</h1>
        <p class="text-white-50 mb-5 small">Secure Gateway for Rizky Dewa Server</p>
        <?php if(isset(\$error)) echo "<p class='text-danger mb-4 small'>\$error</p>"; ?>
        <form method="POST">
            <input type="password" name="password" class="form-control" placeholder="Key Phrase" required>
            <button type="submit" name="login" class="btn-zenith">ACCESS SYSTEM</button>
        </form>
    </div>
</body>
</html>
EOF

# 3. MEMBUAT DASHBOARD UTAMA (ZENITH UI)
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
        \$cmd_output = "System: Command '\$base_cmd' is restricted.";
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Zenith Dashboard | RIZKY DEWA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap');
        
        body { 
            background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center center fixed;
            background-size: cover; color: #fff; font-family: 'Plus Jakarta Sans', sans-serif; min-height: 100vh; overflow-x: hidden;
        }

        @keyframes mainFade { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        .sidebar { 
            width: 280px; height: 100vh; background: rgba(0, 0, 0, 0.2); 
            backdrop-filter: blur(40px); position: fixed; padding: 40px 30px; 
            border-right: 1px solid rgba(255, 255, 255, 0.1); animation: mainFade 0.8s ease;
        }

        .main-content { margin-left: 280px; padding: 60px; animation: mainFade 1s ease; }

        .glass-card { 
            background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(25px); 
            border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 30px; padding: 35px; 
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2); transition: 0.4s;
        }
        .glass-card:hover { transform: translateY(-5px); border-color: rgba(255, 255, 255, 0.3); }

        .terminal-window {
            background: rgba(0, 0, 0, 0.7); border-radius: 20px; 
            overflow: hidden; border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .terminal-header {
            background: rgba(255, 255, 255, 0.05); padding: 15px 25px; 
            display: flex; align-items: center; gap: 10px;
        }

        .dot { width: 12px; height: 12px; border-radius: 50%; }
        .red { background: #ff5f56; } .yellow { background: #ffbd2e; } .green { background: #27c93f; }

        .terminal-body {
            padding: 30px; font-family: 'Courier New', monospace;
            color: #00ffcc; height: 400px; overflow-y: auto; font-size: 14px;
        }

        .cmd-input {
            background: transparent; border: none; color: #fff; width: 100%; 
            outline: none; font-family: 'Courier New', monospace; caret-color: #00ffcc;
        }

        .nav-link-custom {
            padding: 15px 20px; border-radius: 15px; color: rgba(255,255,255,0.5);
            text-decoration: none; display: flex; align-items: center; margin-bottom: 15px; transition: 0.3s;
        }

        .nav-link-custom.active, .nav-link-custom:hover { background: rgba(255, 255, 255, 0.1); color: #fff; }

        .status-badge {
            background: rgba(0, 255, 150, 0.1); border: 1px solid rgba(0, 255, 150, 0.3);
            padding: 8px 20px; border-radius: 50px; font-size: 11px; color: #00ff96; font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="mb-5 px-3">
            <h3 class="fw-bold text-white mb-0">ZENITH</h3>
            <small class="text-white-50">Rizky Dewa OS</small>
        </div>
        <a href="#" class="nav-link-custom active"><i class="fas fa-terminal me-3"></i> Core Console</a>
        <a href="#" class="nav-link-custom"><i class="fas fa-cube me-3"></i> Node Manager</a>
        <a href="#" class="nav-link-custom"><i class="fas fa-shield-alt me-3"></i> Security</a>
        <div style="position: absolute; bottom: 50px; width: 220px;">
            <a href="logout.php" class="nav-link-custom text-danger"><i class="fas fa-power-off me-3"></i> Log Out</a>
        </div>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="fw-bold mb-0">System Control</h2>
            <div class="status-badge"><i class="fas fa-satellite me-2"></i> MASTER CONNECTED</div>
        </div>

        <div class="glass-card">
            <div class="terminal-window">
                <div class="terminal-header">
                    <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                    <span class="ms-3 small text-white-50">root@zenith-server:~</span>
                </div>
                <div class="terminal-body" id="term-body">
                    <?php if (\$cmd_output): ?>
                        <div class="mb-3 opacity-50">> Process execution complete.</div>
                        <pre style="white-space: pre-wrap; line-height: 1.6;"><?php echo htmlspecialchars(\$cmd_output); ?></pre>
                    <?php else: ?>
                        <div class="opacity-50 mb-3">Zenith OS Terminal v1.0.0</div>
                        <div class="small text-white-50">Type 'uptime' or 'ls' to begin...</div>
                    <?php endif; ?>
                    
                    <div class="d-flex align-items-center mt-3">
                        <span class="text-info me-2 fw-bold">#</span>
                        <form method="POST" class="w-100">
                            <input type="text" name="command" class="cmd-input" autofocus autocomplete="off">
                            <input type="submit" name="exec_cmd" style="display: none;">
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mt-5 row g-4">
            <div class="col-md-4">
                <div class="glass-card py-4 text-center">
                    <small class="text-white-50">NETWORK</small>
                    <div class="h4 mt-1 fw-bold">LATENCY: 8ms</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card py-4 text-center">
                    <small class="text-white-50">UPTIME</small>
                    <div class="h4 mt-1 fw-bold">99.9%</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card py-4 text-center">
                    <small class="text-white-50">ENCRYPTION</small>
                    <div class="h4 mt-1 fw-bold">AES-GCM</div>
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
echo "🚀 MENGAKTIFKAN ZENITH CLUSTER..."
sudo docker-compose up -d

echo "------------------------------------------------"
echo "✅ ZENITH ULTRA EDITION DEPLOYED!"
echo "🌐 Akses: http://localhost"
echo "🔑 Password: RIZKY"
echo "✨ Status: PREMIUM"
echo "------------------------------------------------"
