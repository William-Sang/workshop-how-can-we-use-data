#!/bin/bash

# 引爆数据价值工作坊 - 开发服务器启动脚本
# 优先启动模块化版本，支持多种服务器工具

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 默认端口和文件
PORT=8000
DEFAULT_FILE="index.html"

echo -e "${CYAN}🚀 引爆数据价值工作坊 - 开发服务器${NC}"
echo -e "${CYAN}===========================================${NC}"

# 检查端口参数
if [ $# -eq 1 ]; then
    if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -ge 1024 ] && [ $1 -le 65535 ]; then
        PORT=$1
        echo -e "${GREEN}✅ 使用自定义端口: ${PORT}${NC}"
    else
        echo -e "${RED}❌ 无效端口号: $1${NC}"
        echo -e "${YELLOW}💡 用法: $0 [端口号] (1024-65535)${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}📁 当前目录: $(pwd)${NC}"
echo -e "${YELLOW}📍 正在检测可用的服务器工具...${NC}"

# 方法1: 优先使用 live-server (最适合开发)
if command -v live-server &> /dev/null; then
    echo -e "${GREEN}✅ 使用 live-server 启动 (支持热重载)${NC}"
    echo -e "${BLUE}🌐 服务器地址: http://localhost:${PORT}${NC}"
    echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
    echo ""
    live-server --port=$PORT --open=$DEFAULT_FILE --no-browser

# 方法2: 使用 Python 3
elif command -v python3 &> /dev/null; then
    echo -e "${GREEN}✅ 使用 Python 3 http.server${NC}"
    echo -e "${BLUE}🌐 服务器地址: http://localhost:${PORT}${NC}"
    echo -e "${BLUE}📱 主页面: http://localhost:${PORT}/${DEFAULT_FILE}${NC}"
    echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
    echo ""
    python3 -m http.server $PORT --bind 127.0.0.1

# 方法3: 使用 Python (通用)
elif command -v python &> /dev/null; then
    echo -e "${GREEN}✅ 使用 Python http.server${NC}"
    echo -e "${BLUE}🌐 服务器地址: http://localhost:${PORT}${NC}"
    echo -e "${BLUE}📱 主页面: http://localhost:${PORT}/${DEFAULT_FILE}${NC}"
    echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
    echo ""
    python -m http.server $PORT

# 方法4: 使用 Node.js + serve
elif command -v npx &> /dev/null; then
    echo -e "${GREEN}✅ 使用 npx serve${NC}"
    echo -e "${BLUE}🌐 服务器地址: http://localhost:${PORT}${NC}"
    echo -e "${BLUE}📱 主页面: http://localhost:${PORT}/${DEFAULT_FILE}${NC}"
    echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
    echo ""
    npx serve . -p $PORT

# 方法5: 使用 PHP
elif command -v php &> /dev/null; then
    echo -e "${GREEN}✅ 使用 PHP 内置服务器${NC}"
    echo -e "${BLUE}🌐 服务器地址: http://localhost:${PORT}${NC}"
    echo -e "${BLUE}📱 主页面: http://localhost:${PORT}/${DEFAULT_FILE}${NC}"
    echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
    echo ""
    php -S 127.0.0.1:$PORT

else
    echo -e "${RED}❌ 未找到可用的服务器工具${NC}"
    echo -e "${YELLOW}📝 推荐安装以下工具之一：${NC}"
    echo -e "   • live-server (推荐): ${CYAN}npm install -g live-server${NC}"
    echo -e "   • Python 3: ${CYAN}sudo apt install python3${NC}"
    echo -e "   • Node.js: ${CYAN}sudo apt install nodejs npm${NC}"
    echo ""
    echo -e "${BLUE}💡 或者直接在浏览器中打开 file://$(pwd)/${DEFAULT_FILE}${NC}"
    exit 1
fi
