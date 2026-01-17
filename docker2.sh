#!/bin/bash

# --- CONFIGURATION ---
PROJECT_NAME="rizky_dewa_server"
PASS_KEY="RIZKY"
DEFAULT_PORT=80

echo "🔥 DEPLOYING ZENITH OVERKILL EDITION..."
echo "------------------------------------------------"

# 1. AUTO-PORT DETECTION (Advanced)
PORT=$DEFAULT_PORT
while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; do
    echo "⚠️  Port $PORT busy, shifting to $((PORT+1))..."
    PORT=$((PORT+1))
done

mkdir -p $PROJECT_NAME/html
cd $PROJECT_NAME

# 2. DOCKER COMPOSE
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  rizky-app:
    image: php:8.2-apache
    container_name: rizky_dewa_container
    ports:
      - "$PORT:80"
    volumes:
      - ./html:/var/www/html
    restart: always
EOF

# 3. LOGIN PAGE (THE OVERKILL VERSION)
cat <<EOF > html/login.php
<?php
session_start();
if (isset(\$_POST['login'])) {
    if (\$_POST['password'] == "$PASS_KEY") {
        \$_SESSION['loggedin'] = true;
        header("Location: index.php"); exit;
    } else { \$error = "INVALID ACCESS KEY"; }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Zenith Alpha | Secure Access</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700;800&display=swap');
        body { 
            background: radial-gradient(circle at center, rgba(0,0,0,0) 0%, rgba(0,0,0,0.8) 100%), 
                        url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center fixed;
            background-size: cover; height: 100vh; display: flex; align-items: center; justify-content: center;
            font-family: 'Plus Jakarta Sans', sans-serif; color: white; overflow: hidden;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(40px);
            border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 50px;
            padding: 70px; width: 480px; text-align: center;
            box-shadow: 0 50px 100px rgba(0,0,0,0.6), inset 0 0 20px rgba(255,255,255,0.05);
            animation: ultraAppear 1.5s cubic-bezier(0.19, 1, 0.22, 1);
        }
        @keyframes ultraAppear { 
            from { opacity: 0; transform: scale(0.7) translateY(50px) rotateX(-20deg); } 
            to { opacity: 1; transform: scale(1) translateY(0) rotateX(0); } 
        }
        input { 
            background: rgba(0, 0, 0, 0.2) !important; border: 1px solid rgba(255, 255, 255, 0.1) !important;
            color: white !important; border-radius: 18px !important; padding: 18px !important;
            text-align: center; margin-bottom: 30px; font-weight: 600; font-size: 1.1rem;
            transition: all 0.4s ease;
        }
        input:focus { border-color: #0070f3 !important; box-shadow: 0 0 30px rgba(0,112,243,0.3) !important; background: rgba(0,0,0,0.4) !important; }
        .btn-glow {
            background: linear-gradient(135deg, #0070f3, #00c6ff); border: none; color: white;
            width: 100%; padding: 18px; border-radius: 18px; font-weight: 800;
            letter-spacing: 2px; transition: all 0.5s; box-shadow: 0 10px 40px rgba(0,112,243,0.4);
        }
        .btn-glow:hover { transform: translateY(-5px); box-shadow: 0 20px 50px rgba(0,112,243,0.6); filter: brightness(1.1); }
    </style>
</head>
<body>
    <div class="login-card">
        <h1 style="font-size: 3rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 10px;">ZENITH</h1>
        <p style="opacity: 0.5; font-size: 0.9rem; margin-bottom: 50px;">LEVEL 4 ENCRYPTION ACTIVE</p>
        <form method="POST">
            <input type="password" name="password" class="form-control" placeholder="ACCESS KEY" required>
            <button type="submit" name="login" class="btn-glow">BYPASS FIREWALL</button>
        </form>
    </div>
</body>
</html>
EOF

# 4. DASHBOARD PAGE (THE OVERKILL VERSION)
cat <<EOF > html/index.php
<?php
session_start();
if (!isset(\$_SESSION['loggedin'])) { header("Location: login.php"); exit; }
\$cmd_output = "";
if (isset(\$_POST['exec_cmd'])) {
    \$cmd = \$_POST['command'];
    \$allowed = ['ls', 'whoami', 'pwd', 'date', 'uptime', 'free', 'hostname', 'df', 'top'];
    if (in_array(explode(' ', trim(\$cmd))[0], \$allowed)) { \$cmd_output = shell_exec(\$cmd . " 2>&1"); }
    else { \$cmd_output = "System: Unauthorized Command String."; }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Zenith OS | Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700;800&display=swap');
        body { 
            background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center fixed;
            background-size: cover; color: white; font-family: 'Plus Jakarta Sans', sans-serif; min-height: 100vh;
        }
        .sidebar { 
            width: 300px; height: 100vh; background: rgba(0,0,0,0.4); backdrop-filter: blur(50px);
            position: fixed; padding: 50px 30px; border-right: 1px solid rgba(255,255,255,0.1);
        }
        .main-content { margin-left: 300px; padding: 80px; animation: dashboardFade 1.2s ease; }
        @keyframes dashboardFade { from { opacity: 0; transform: translateX(30px); } to { opacity: 1; transform: translateX(0); } }
        .glass-card { 
            background: rgba(255,255,255,0.03); backdrop-filter: blur(30px);
            border: 1px solid rgba(255,255,255,0.1); border-radius: 40px; padding: 40px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.3); transition: 0.5s;
        }
        .glass-card:hover { transform: translateY(-10px); border-color: rgba(255,255,255,0.3); }
        .terminal-box {
            background: rgba(0,0,0,0.85); border-radius: 25px; border: 1px solid rgba(0,112,243,0.5);
            overflow: hidden; box-shadow: inset 0 0 30px rgba(0,0,0,1);
        }
        .term-header { background: rgba(255,255,255,0.05); padding: 20px 30px; display: flex; align-items: center; justify-content: space-between; }
        .dots { display: flex; gap: 8px; }
        .dot { width: 13px; height: 13px; border-radius: 50%; }
        .term-body { padding: 35px; height: 400px; overflow-y: auto; font-family: 'Courier New', monospace; color: #00ffcc; font-size: 15px; line-height: 1.6; }
        .cmd-input { background: transparent; border: none; color: white; width: 100%; outline: none; font-size: 15px; caret-color: #00ffcc; }
        .nav-item { padding: 18px 25px; border-radius: 20px; color: rgba(255,255,255,0.4); text-decoration: none; display: flex; align-items: center; margin-bottom: 20px; transition: 0.4s; font-weight: 600; }
        .nav-item.active, .nav-item:hover { background: rgba(255,255,255,0.1); color: white; transform: translateX(10px); }
        .stat-card { background: rgba(255,255,255,0.05); border-radius: 25px; padding: 25px; border: 1px solid rgba(255,255,255,0.05); }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="mb-5">
            <h2 class="fw-bold m-0">ZENITH</h2>
            <p class="small opacity-40">System Administrator</p>
        </div>
        <a href="#" class="nav-item active"><i class="fas fa-terminal me-3"></i> Core Console</a>
        <a href="#" class="nav-item"><i class="fas fa-microchip me-3"></i> Processor</a>
        <a href="#" class="nav-item"><i class="fas fa-database me-3"></i> Database</a>
        <a href="logout.php" class="nav-item text-danger mt-5"><i class="fas fa-power-off me-3"></i> Terminate</a>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-end mb-5">
            <div>
                <h1 class="fw-bold m-0">Command Center</h1>
                <p class="opacity-50">Interface v4.2.0-Alpha</p>
            </div>
            <div style="background: rgba(0,255,150,0.1); color: #00ff96; padding: 12px 30px; border-radius: 100px; border: 1px solid rgba(0,255,150,0.3); font-weight: 800; font-size: 11px; letter-spacing: 1px;">
                ● LINK ESTABLISHED
            </div>
        </div>

        <div class="glass-card mb-5">
            <div class="terminal-box">
                <div class="term-header">
                    <div class="dots">
                        <div class="dot" style="background:#ff5f56"></div>
                        <div class="dot" style="background:#ffbd2e"></div>
                        <div class="dot" style="background:#27c93f"></div>
                    </div>
                    <small class="opacity-50">SH-6.1 / rizky@zenith-server</small>
                </div>
                <div class="term-body" id="term">
                    <?php if(\$cmd_output): ?>
                        <div style="color: #666; font-size: 12px; margin-bottom: 10px;">> EXECUTION LOG:</div>
                        <pre style="white-space: pre-wrap;"><?php echo htmlspecialchars(\$cmd_output); ?></pre>
                    <?php endif; ?>
                    <div class="d-flex">
                        <span class="text-info me-2 fw-bold">#</span>
                        <form method="POST" class="w-100">
                            <input type="text" name="command" class="cmd-input" autofocus autocomplete="off">
                            <input type="submit" name="exec_cmd" hidden>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-3"><div class="stat-card"><h6>CORE TEMP</h6><h3 class="fw-bold m-0">32°C</h3></div></div>
            <div class="col-md-3"><div class="stat-card"><h6>RAM USAGE</h6><h3 class="fw-bold m-0">12%</h3></div></div>
            <div class="col-md-3"><div class="stat-card"><h6>LATENCY</h6><h3 class="fw-bold m-0">4ms</h3></div></div>
            <div class="col-md-3"><div class="stat-card"><h6>NODES</h6><h3 class="fw-bold m-0">ACTIVE</h3></div></div>
        </div>
    </div>
    <script>const t = document.getElementById('term'); t.scrollTop = t.scrollHeight;</script>
</body>
</html>
EOF

# 5. WRAPPING UP
echo "<?php session_start(); session_destroy(); header('Location: login.php'); ?>" > html/logout.php
chmod -R 755 html/
docker-compose up -d --quiet-pull

echo "------------------------------------------------"
echo "✅ ZENITH OVERKILL EDITION READY!"
echo "🌐 Akses di: http://localhost:$PORT"
echo "🔑 Password: $PASS_KEY"
echo "------------------------------------------------"
