#!/bin/bash

# 引爆数据价值工作坊 - 快速启动脚本
# 自动检测可用工具并启动本地服务器预览网页

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 默认端口
PORT=8080

echo -e "${CYAN}🚀 引爆数据价值工作坊 - 快速启动脚本${NC}"
echo -e "${CYAN}========================================${NC}"

# 检查并尝试启动服务器
start_server() {
    echo -e "${YELLOW}📍 正在检测可用的服务器工具...${NC}"
    
    # 方法1: 尝试使用 Python 3
    if command -v python3 >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 发现 Python 3，使用内置 http.server${NC}"
        echo -e "${BLUE}🌐 启动本地服务器: http://localhost:${PORT}${NC}"
        echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
        echo ""
        python3 -m http.server $PORT --bind 127.0.0.1
        return
    fi
    
    # 方法2: 尝试使用 Python 2
    if command -v python2 >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 发现 Python 2，使用 SimpleHTTPServer${NC}"
        echo -e "${BLUE}🌐 启动本地服务器: http://localhost:${PORT}${NC}"
        echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
        echo ""
        python2 -m SimpleHTTPServer $PORT
        return
    fi
    
    # 方法3: 尝试使用 Python (通用)
    if command -v python >/dev/null 2>&1; then
        PYTHON_VERSION=$(python --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1)
        if [ "$PYTHON_VERSION" = "3" ]; then
            echo -e "${GREEN}✅ 发现 Python 3，使用内置 http.server${NC}"
            echo -e "${BLUE}🌐 启动本地服务器: http://localhost:${PORT}${NC}"
            echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
            echo ""
            python -m http.server $PORT --bind 127.0.0.1
        else
            echo -e "${GREEN}✅ 发现 Python 2，使用 SimpleHTTPServer${NC}"
            echo -e "${BLUE}🌐 启动本地服务器: http://localhost:${PORT}${NC}"
            echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
            echo ""
            python -m SimpleHTTPServer $PORT
        fi
        return
    fi
    
    # 方法4: 尝试使用 Node.js + http-server
    if command -v npx >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 发现 Node.js，使用 http-server${NC}"
        echo -e "${BLUE}🌐 启动本地服务器: http://localhost:${PORT}${NC}"
        echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
        echo ""
        npx http-server -p $PORT -a 127.0.0.1 -o
        return
    fi
    
    # 方法5: 尝试使用 PHP
    if command -v php >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 发现 PHP，使用内置服务器${NC}"
        echo -e "${BLUE}🌐 启动本地服务器: http://localhost:${PORT}${NC}"
        echo -e "${YELLOW}💡 按 Ctrl+C 停止服务器${NC}"
        echo ""
        php -S 127.0.0.1:$PORT
        return
    fi
    
    # 如果没有找到任何工具
    echo -e "${RED}❌ 未找到可用的服务器工具${NC}"
    echo -e "${YELLOW}📝 请安装以下任一工具：${NC}"
    echo -e "   • Python 3: ${CYAN}sudo apt install python3${NC}"
    echo -e "   • Node.js: ${CYAN}sudo apt install nodejs npm${NC}"
    echo -e "   • PHP: ${CYAN}sudo apt install php${NC}"
    echo ""
    echo -e "${BLUE}💡 或者直接在浏览器中打开 file://$(pwd)/index.html${NC}"
    exit 1
}

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
elif [ $# -gt 1 ]; then
    echo -e "${RED}❌ 参数过多${NC}"
    echo -e "${YELLOW}💡 用法: $0 [端口号]${NC}"
    exit 1
fi

# 检查index.html是否存在
if [ ! -f "index.html" ]; then
    echo -e "${RED}❌ 未找到 index.html 文件${NC}"
    echo -e "${YELLOW}💡 请确保在包含 index.html 的目录中运行此脚本${NC}"
    exit 1
fi

# 检查端口是否被占用
if command -v lsof >/dev/null 2>&1; then
    if lsof -i:$PORT >/dev/null 2>&1; then
        echo -e "${RED}❌ 端口 $PORT 已被占用${NC}"
        echo -e "${YELLOW}💡 请选择其他端口或关闭占用该端口的程序${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}📁 当前目录: $(pwd)${NC}"
echo -e "${GREEN}📄 发现文件: index.html${NC}"
echo ""

# 启动服务器
start_server 