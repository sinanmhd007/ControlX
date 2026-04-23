const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const { exec } = require('child_process');
const os = require('os');
const crypto = require('crypto');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: "*", methods: ["GET", "POST"] }
});

const PORT = process.env.PORT || 3000;

// Security settings
const PAIRING_PIN = Math.floor(100000 + Math.random() * 900000).toString();
const ACTIVE_TOKENS = new Set();
console.log('\n=========================================');
console.log(`YOUR CONTROLX PAIRING PIN IS: ${PAIRING_PIN}`);
console.log('=========================================\n');

app.use(cors());
app.use(express.json());

// Auth Middleware (protects routes)
function authenticate(req, res, next) {
  const authHeader = req.headers['authorization'];
  if (!authHeader) return res.status(401).json({ error: 'Missing Authorization header' });
  
  const token = authHeader.split(' ')[1];
  if (!ACTIVE_TOKENS.has(token)) return res.status(403).json({ error: 'Invalid or expired token' });
  
  req.token = token;
  next();
}

app.post('/pair', (req, res) => {
  const { pin } = req.body;
  if (!pin) return res.status(400).json({ error: 'PIN required' });
  
  if (pin === PAIRING_PIN) {
    const token = crypto.randomBytes(32).toString('hex');
    ACTIVE_TOKENS.add(token);
    return res.json({ success: true, token });
  } else {
    return res.status(401).json({ error: 'Incorrect PIN' });
  }
});

function getSystemInfo() {
  const cpus = os.cpus();
  const cpuModel = cpus[0] ? cpus[0].model : 'Unknown';
  const totalMem = os.totalmem();
  const freeMem = os.freemem();
  const usedMem = totalMem - freeMem;
  return {
    cpu: cpuModel,
    ram: {
      total_GB: (totalMem / (1024 ** 3)).toFixed(2),
      used_GB: (usedMem / (1024 ** 3)).toFixed(2),
      free_GB: (freeMem / (1024 ** 3)).toFixed(2),
      usage_percent: ((usedMem / totalMem) * 100).toFixed(1)
    },
    platform: os.platform(),
    uptime_seconds: os.uptime(),
  };
}

// Socket Auth Middleware
io.use((socket, next) => {
  const token = socket.handshake.auth.token;
  if (ACTIVE_TOKENS.has(token)) {
    next();
  } else {
    next(new Error("Authentication error"));
  }
});

io.on('connection', (socket) => {
  let intervalId;
  socket.on('connect_device', () => {
    socket.emit('system_update', getSystemInfo());
    if (intervalId) clearInterval(intervalId);
    intervalId = setInterval(() => {
      socket.emit('system_update', getSystemInfo());
    }, 5000);
  });
  
  socket.on('disconnect', () => {
    if (intervalId) clearInterval(intervalId);
  });
});

app.post('/command', authenticate, (req, res) => {
  const { action } = req.body;
  let cmd = '';

  if (action === 'open_chrome') {
    cmd = process.platform === 'win32' ? 'start chrome' : 'google-chrome';
  
  } else if (action === 'open_cmd') {
    cmd = process.platform === 'win32' ? 'start cmd' : 'gnome-terminal';
  
  } else if (action === 'open_vscode') {
  cmd = 'code';
  
  } else if (action === 'file_explorer') {
  cmd = process.platform === 'win32'
    ? 'start .'
    : 'xdg-open .';
}
  
  else if (action === 'restart') {
  cmd = process.platform === 'win32'
    ? 'shutdown /r /t 0'
    : 'reboot';
  
  } else if (action === 'shutdown') {
    cmd = process.platform === 'win32' ? 'shutdown /s /t 0' : 'shutdown now';
  
  } else {
    // simplified mock
    return res.json({ success: true, message: `Mock Executed: ${action}` });
  }

  exec(cmd, (error, stdout) => {
    if (error) return res.status(500).json({ error: 'Failed', details: error.message });
    return res.json({ success: true, message: `Executed: ${action}` });
  });
});

app.get('/system-info', authenticate, (req, res) => {
  res.json({ success: true, data: getSystemInfo() });
});

server.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
