const { app, BrowserWindow, Menu, ipcMain, shell } = require('electron');
const path = require('path');
const { spawn } = require('child_process');

// Keep a global reference of the window object
let mainWindow;
let gitpushProcess;

function createWindow() {
  // Create the browser window
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    icon: path.join(__dirname, '../assets/icon.png'),
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true
    },
    titleBarStyle: 'hiddenInset',
    backgroundColor: '#1e1e2e',
    show: false
  });

  // Load the index.html
  mainWindow.loadFile(path.join(__dirname, 'index.html'));

  // Show window when ready
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  // Open DevTools in dev mode
  if (process.argv.includes('--dev')) {
    mainWindow.webContents.openDevTools();
  }

  // Handle window closed
  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// Create app menu
function createMenu() {
  const template = [
    {
      label: 'Gitpush',
      submenu: [
        {
          label: 'About Gitpush',
          click: () => {
            shell.openExternal('https://github.com/karlblock/gitpush');
          }
        },
        { type: 'separator' },
        {
          label: 'Preferences',
          accelerator: 'CmdOrCtrl+,',
          click: () => {
            mainWindow.webContents.send('open-preferences');
          }
        },
        { type: 'separator' },
        { role: 'quit' }
      ]
    },
    {
      label: 'File',
      submenu: [
        {
          label: 'New Repository',
          accelerator: 'CmdOrCtrl+N',
          click: () => {
            mainWindow.webContents.send('new-repo');
          }
        },
        {
          label: 'Open Repository',
          accelerator: 'CmdOrCtrl+O',
          click: () => {
            mainWindow.webContents.send('open-repo');
          }
        },
        { type: 'separator' },
        {
          label: 'Refresh',
          accelerator: 'CmdOrCtrl+R',
          click: () => {
            mainWindow.webContents.send('refresh');
          }
        }
      ]
    },
    {
      label: 'Git',
      submenu: [
        {
          label: 'Commit',
          accelerator: 'CmdOrCtrl+K',
          click: () => {
            mainWindow.webContents.send('git-commit');
          }
        },
        {
          label: 'Push',
          accelerator: 'CmdOrCtrl+P',
          click: () => {
            mainWindow.webContents.send('git-push');
          }
        },
        {
          label: 'Pull',
          accelerator: 'CmdOrCtrl+Shift+P',
          click: () => {
            mainWindow.webContents.send('git-pull');
          }
        },
        { type: 'separator' },
        {
          label: 'AI Commit Message',
          accelerator: 'CmdOrCtrl+Shift+K',
          click: () => {
            mainWindow.webContents.send('ai-commit');
          }
        }
      ]
    },
    {
      label: 'Issues',
      submenu: [
        {
          label: 'List Issues',
          click: () => {
            mainWindow.webContents.send('list-issues');
          }
        },
        {
          label: 'Create Issue',
          click: () => {
            mainWindow.webContents.send('create-issue');
          }
        }
      ]
    },
    {
      label: 'View',
      submenu: [
        { role: 'reload' },
        { role: 'toggledevtools' },
        { type: 'separator' },
        { role: 'resetzoom' },
        { role: 'zoomin' },
        { role: 'zoomout' },
        { type: 'separator' },
        { role: 'togglefullscreen' }
      ]
    },
    {
      label: 'Help',
      submenu: [
        {
          label: 'Documentation',
          click: () => {
            shell.openExternal('https://github.com/karlblock/gitpush#readme');
          }
        },
        {
          label: 'Report Issue',
          click: () => {
            shell.openExternal('https://github.com/karlblock/gitpush/issues');
          }
        }
      ]
    }
  ];

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

// App event handlers
app.whenReady().then(() => {
  createWindow();
  createMenu();
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// IPC handlers for gitpush operations
ipcMain.handle('execute-gitpush', async (event, args) => {
  return new Promise((resolve, reject) => {
    const gitpushPath = path.join(__dirname, '../../gitpush.sh');
    const process = spawn('bash', [gitpushPath, ...args]);
    
    let output = '';
    let error = '';
    
    process.stdout.on('data', (data) => {
      output += data.toString();
      event.sender.send('gitpush-output', data.toString());
    });
    
    process.stderr.on('data', (data) => {
      error += data.toString();
      event.sender.send('gitpush-error', data.toString());
    });
    
    process.on('close', (code) => {
      if (code === 0) {
        resolve(output);
      } else {
        reject(new Error(error || `Process exited with code ${code}`));
      }
    });
  });
});

// Handle AI configuration
ipcMain.handle('get-ai-config', async () => {
  return {
    provider: process.env.AI_PROVIDER || 'none',
    hasOpenAI: !!process.env.OPENAI_API_KEY,
    hasAnthropic: !!process.env.ANTHROPIC_API_KEY,
    hasGoogle: !!process.env.GOOGLE_API_KEY
  };
});

ipcMain.handle('set-ai-config', async (event, config) => {
  // In real implementation, save to user preferences
  return { success: true };
});