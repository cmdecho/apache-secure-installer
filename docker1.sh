#!/bin/bash

# --- CONFIGURATION ---
PROJECT_NAME="rizky_dewa_server"
PASS_KEY="RIZKY"
DEFAULT_PORT=80

echo "💎 ZENITH FULL-THROTTLE: HIGH-END UI + AUTO-HEAL"
echo "------------------------------------------------"

# 1. AUTO-PORT DETECTION
PORT=$DEFAULT_PORT
while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; do
    echo "⚠️  Port $PORT sibuk, mencoba port $((PORT+1))..."
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

# 3. LOGIN PAGE (PREMIUM VERSION)
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
    <title>Zenith | Secure Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700&display=swap');
        body { background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center fixed; background-size: cover; height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Plus Jakarta Sans', sans-serif; overflow: hidden; }
        .login-card { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(40px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 40px; padding: 60px; width: 450px; text-align: center; color: white; box-shadow: 0 40px 100px rgba(0,0,0,0.5); animation: cardIn 1.2s cubic-bezier(0.16, 1, 0.3, 1); }
        @keyframes cardIn { from { opacity: 0; transform: scale(0.8) translateY(30px); } to { opacity: 1; transform: scale(1) translateY(0); } }
        input { background: rgba(255, 255, 255, 0.1) !important; border: 1px solid rgba(255, 255, 255, 0.2) !important; color: white !important; border-radius: 15px !important; padding: 15px !important; text-align: center; margin-bottom: 25px; }
        .btn-zenith { background: linear-gradient(135deg, #0070f3, #00c6ff); border: none; color: white; width: 100%; padding: 15px; border-radius: 15px; font-weight: 700; transition: 0.4s; letter-spacing: 1px; }
        .btn-zenith:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(0, 112, 243, 0.4); }
    </style>
</head>
<body>
    <div class="login-card">
        <h1 class="fw-bold mb-2">ZENITH</h1>
        <p class="text-white-50 mb-5 small">ENTER ACCESS KEY TO PROCEED</p>
        <form method="POST">
            <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            <button type="submit" name="login" class="btn-zenith">AUTHENTICATE SYSTEM</button>
        </form>
    </div>
</body>
</html>
EOF

# 4. DASHBOARD PAGE (FULL VERSION WITH CARDS)
cat <<EOF > html/index.php
<?php
session_start();
if (!isset(\$_SESSION['loggedin'])) { header("Location: login.php"); exit; }
\$cmd_output = "";
if (isset(\$_POST['exec_cmd'])) {
    \$cmd = \$_POST['command'];
    \$allowed = ['ls', 'whoami', 'pwd', 'date', 'uptime', 'free', 'hostname'];
    if (in_array(explode(' ', trim(\$cmd))[0], \$allowed)) { \$cmd_output = shell_exec(\$cmd . " 2>&1"); }
    else { \$cmd_output = "System: Permission Restricted."; }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Zenith | Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap');
        body { background: url('https://images.hdqwalls.com/download/windows-11-stock-original-4k-mm-1920x1080.jpg') no-repeat center fixed; background-size: cover; color: white; font-family: 'Plus Jakarta Sans', sans-serif; min-height: 100vh; }
        .sidebar { width: 280px; height: 100vh; background: rgba(0,0,0,0.2); backdrop-filter: blur(40px); position: fixed; padding: 40px; border-right: 1px solid rgba(255,255,255,0.1); transition: 0.3s; }
        .main-content { margin-left: 280px; padding: 60px; animation: fadeIn 1s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(25px); border: 1px solid rgba(255,255,255,0.1); border-radius: 30px; padding: 35px; box-shadow: 0 20px 50px rgba(0,0,0,0.2); }
        .terminal { background: rgba(0,0,0,0.75); border-radius: 20px; border: 1px solid rgba(0,112,243,0.3); overflow: hidden; }
        .term-header { background: rgba(255,255,255,0.05); padding: 15px 25px; display: flex; align-items: center; gap: 10px; font-size: 13px; }
        .dot { width: 12px; height: 12px; border-radius: 50%; }
        .term-body { padding: 30px; height: 350px; overflow-y: auto; font-family: 'Courier New', monospace; color: #00ffcc; font-size: 14px; }
        .cmd-input { background: transparent; border: none; color: white; width: 100%; outline: none; }
        .nav-link-custom { padding: 15px 20px; border-radius: 15px; color: rgba(255,255,255,0.5); text-decoration: none; display: flex; align-items: center; margin-bottom: 15px; transition: 0.3s; }
        .nav-link-custom.active, .nav-link-custom:hover { background: rgba(255,255,255,0.1); color: white; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h3 class="fw-bold mb-5">ZENITH</h3>
        <a href="#" class="nav-link-custom active"><i class="fas fa-terminal me-3"></i> Console</a>
        <a href="#" class="nav-link-custom"><i class="fas fa-server me-3"></i> Nodes</a>
        <a href="logout.php" class="nav-link-custom text-danger mt-5"><i class="fas fa-power-off me-3"></i> Shutdown</a>
    </div>
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="fw-bold">System Control</h2>
            <div style="background: rgba(0,255,150,0.1); color: #00ff96; padding: 8px 20px; border-radius: 50px; border: 1px solid rgba(0,255,150,0.3); font-size: 12px; font-weight: 700;">● ONLINE</div>
        </div>
        <div class="glass-card">
            <div class="terminal">
                <div class="term-header">
                    <div class="dot" style="background:#ff5f56"></div><div class="dot" style="background:#ffbd2e"></div><div class="dot" style="background:#27c93f"></div>
                    <span class="ms-2 opacity-50">root@zenith:~</span>
                </div>
                <div class="term-body" id="term">
                    <?php if(\$cmd_output) echo "<pre style='white-space:pre-wrap'>".htmlspecialchars(\$cmd_output)."</pre>"; ?>
                    <div class="d-flex align-items-center">
                        <span class="text-info me-2 fw-bold">#</span>
                        <form method="POST" class="w-100"><input type="text" name="command" class="cmd-input" autofocus autocomplete="off"><input type="submit" name="exec_cmd" hidden></form>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mt-4 g-4">
            <div class="col-md-4"><div class="glass-card p-4 text-center"><small class="opacity-50">NETWORK</small><div class="h5 fw-bold mt-1">8ms Latency</div></div></div>
            <div class="col-md-4"><div class="glass-card p-4 text-center"><small class="opacity-50">STABILITY</small><div class="h5 fw-bold mt-1">99.9% Uptime</div></div></div>
            <div class="col-md-4"><div class="glass-card p-4 text-center"><small class="opacity-50">SECURITY</small><div class="h5 fw-bold mt-1">AES-256 Enabled</div></div></div>
        </div>
    </div>
    <script>const t = document.getElementById('term'); t.scrollTop = t.scrollHeight;</script>
</body>
</html>
EOF

# 5. FINALIZING
echo "<?php session_start(); session_destroy(); header('Location: login.php'); ?>" > html/logout.php
chmod -R 755 html/
docker-compose up -d

echo "------------------------------------------------"
echo "✅ ZENITH FULL-THROTTLE DEPLOYED!"
echo "🌐 Akses: http://localhost:$PORT"
echo "🔑 Password: $PASS_KEY"
echo "------------------------------------------------"
