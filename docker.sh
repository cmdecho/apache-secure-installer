#!/bin/bash

PROJECT_NAME="rizky_dewa_server"
mkdir -p $PROJECT_NAME/html
cd $PROJECT_NAME

echo "⌨️ Mengupgrade RIZKY DEWA SERVER ke Terminal Commander Edition..."

# 1. Docker Compose
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

# 2. Update Dashboard dengan Remote Console (index.php)
cat <<EOF > html/index.php
<?php
session_start();
if (!isset(\$_SESSION['loggedin'])) { header("Location: login.php"); exit; }

// Logika Remote Console Sederhana
\$cmd_output = "";
if (isset(\$_POST['exec_cmd'])) {
    \$cmd = \$_POST['command'];
    // Daftar perintah yang diizinkan (White-list) demi keamanan
    \$allowed_cmds = ['ls', 'whoami', 'pwd', 'date', 'uptime', 'free', 'hostname'];
    
    // Ambil kata pertama dari perintah
    \$base_cmd = explode(' ', trim(\$cmd))[0];
    
    if (in_array(\$base_cmd, \$allowed_cmds)) {
        \$cmd_output = shell_exec(\$cmd . " 2>&1");
    } else {
        \$cmd_output = "Akses Ditolak: Perintah '\$base_cmd' tidak diizinkan demi keamanan.";
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Commander Panel | RIZKY DEWA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #0c0c0e; color: #fff; font-family: 'Inter', sans-serif; }
        .sidebar { width: 280px; height: 100vh; background: #000; position: fixed; border-right: 1px solid #222; padding: 30px; }
        .main-content { margin-left: 280px; padding: 40px; }
        .terminal-card { background: #000; border: 1px solid #333; border-radius: 12px; overflow: hidden; }
        .terminal-header { background: #1a1a1a; padding: 10px 20px; font-size: 12px; color: #aaa; border-bottom: 1px solid #333; }
        .terminal-body { padding: 20px; font-family: 'Courier New', monospace; color: #0f0; min-height: 200px; max-height: 400px; overflow-y: auto; }
        .cmd-input { background: transparent; border: none; color: #0f0; width: 100%; outline: none; font-family: 'Courier New', monospace; }
        .info-pill { background: rgba(0, 112, 243, 0.1); border: 1px solid #0070f3; color: #0070f3; padding: 5px 15px; border-radius: 8px; font-size: 12px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h3 class="fw-bold text-primary mb-5"><i class="fas fa-terminal me-2"></i>COMMANDER</h3>
        <nav class="nav flex-column gap-3">
            <a href="#" class="text-white text-decoration-none active"><i class="fas fa-square-terminal me-2"></i> Remote Shell</a>
            <a href="#" class="text-secondary text-decoration-none"><i class="fas fa-box me-2"></i> Containers</a>
            <a href="logout.php" class="text-danger text-decoration-none mt-5"><i class="fas fa-power-off me-2"></i> Terminate Session</a>
        </nav>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h1 class="fw-bold mb-0 text-white">Cloud Terminal</h1>
                <p class="text-secondary small">Direct access to containerized environment</p>
            </div>
            <div class="info-pill">SYSTEM: ONLINE</div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="terminal-card">
                    <div class="terminal-header">
                        <i class="fas fa-circle text-danger me-1"></i>
                        <i class="fas fa-circle text-warning me-1"></i>
                        <i class="fas fa-circle text-success me-1"></i>
                        <span class="ms-3">rizky@docker-container:~</span>
                    </div>
                    <div class="terminal-body" id="term-body">
                        <?php if (\$cmd_output): ?>
                            <div class="text-secondary mb-2">> Perintah dijalankan...</div>
                            <pre><?php echo htmlspecialchars(\$cmd_output); ?></pre>
                        <?php else: ?>
                            <div class="text-secondary">Selamat datang di RIZKY_OS Console. Ketik perintah untuk memulai.</div>
                            <div class="small text-muted mb-3">Tersedia: ls, whoami, pwd, date, uptime, free</div>
                        <?php endif; ?>
                        
                        <div class="d-flex align-items-center">
                            <span class="text-primary me-2">rizky#</span>
                            <form method="POST" class="w-100">
                                <input type="text" name="command" class="cmd-input" placeholder="..." autofocus autocomplete="off">
                                <input type="submit" name="exec_cmd" style="display: none;">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4 row g-3">
            <div class="col-md-4">
                <div class="p-3 border border-secondary rounded bg-dark small">
                    <i class="fas fa-info-circle text-info me-2"></i> 
                    <strong>Tip:</strong> Ketik <code>uptime</code> untuk cek durasi server menyala.
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-3 border border-secondary rounded bg-dark small">
                    <i class="fas fa-user-secret text-warning me-2"></i> 
                    <strong>Status:</strong> Mode Sandbox Aktif.
                </div>
            </div>
        </div>
    </div>

    <script>
        // Auto-scroll terminal ke bawah
        const body = document.getElementById('term-body');
        body.scrollTop = body.scrollHeight;
    </script>
</body>
</html>
EOF

# 3. Jalankan Docker
sudo docker-compose up -d

echo "------------------------------------------------"
echo "✅ TERMINAL COMMANDER EDITION DEPLOYED!"
echo "⌨️  Buka dashboard dan coba ketik: uptime"
echo "🌐 Akses: http://localhost"
echo "------------------------------------------------"
