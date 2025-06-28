# 引爆数据价值工作坊 - 快速启动指南

## 🚀 快速启动

### Linux/macOS 系统
```bash
./start.sh
```

### Windows 系统
```cmd
start.bat
```

### 自定义端口
```bash
# Linux/macOS
./start.sh 3000

# Windows
start.bat 3000
```

## 📋 功能特性

- 🔍 **智能检测**: 自动检测系统中可用的服务器工具
- 🌐 **多工具支持**: 支持 Python、Node.js、PHP 等多种服务器
- 🎯 **零配置**: 开箱即用，无需额外配置
- 🛠 **端口自定义**: 支持自定义端口号
- 🔒 **安全检查**: 自动检查端口占用和文件存在性
- 🎨 **友好界面**: 彩色输出和清晰的状态提示

## 🛠 支持的服务器工具

脚本会按以下优先级自动检测并使用：

1. **Python 3** - `python3 -m http.server`
2. **Python 2** - `python2 -m SimpleHTTPServer`
3. **Node.js** - `npx http-server`
4. **PHP** - `php -S`

## 📝 使用说明

1. 确保您在包含 `index.html` 的目录中运行脚本
2. 脚本会自动检测可用的服务器工具
3. 启动成功后，在浏览器中访问 `http://localhost:8080`
4. 按 `Ctrl+C` 停止服务器

## 🔧 故障排除

### 端口被占用
如果默认端口 8080 被占用，请尝试使用其他端口：
```bash
./start.sh 3000
```

### 没有可用的服务器工具
请安装以下任一工具：

- **Python 3**: 
  - Ubuntu/Debian: `sudo apt install python3`
  - macOS: `brew install python3`
  - Windows: [官方下载](https://www.python.org/downloads/)

- **Node.js**:
  - Ubuntu/Debian: `sudo apt install nodejs npm`
  - macOS: `brew install node`
  - Windows: [官方下载](https://nodejs.org/)

- **PHP**:
  - Ubuntu/Debian: `sudo apt install php`
  - macOS: `brew install php`
  - Windows: [官方下载](https://www.php.net/downloads)

### 直接打开文件
如果无法安装任何服务器工具，可以直接在浏览器中打开：
```
file:///path/to/your/project/index.html
```

## 📁 项目结构

```
workshop-how-can-we-use-date/
├── index.html          # 工作坊主页面
├── start.sh           # Linux/macOS 启动脚本
├── start.bat          # Windows 启动脚本
└── README.md          # 使用说明
```

## 💡 提示

- 首次运行 Node.js 方式可能需要下载 `http-server` 包，请耐心等待
- 建议使用现代浏览器（Chrome、Firefox、Safari、Edge）以获得最佳体验
- 工作坊页面支持键盘导航：左右箭头键切换步骤 