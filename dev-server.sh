#!/bin/bash

# 开发服务器启动脚本
echo "🚀 启动开发服务器..."

# 检查是否安装了 live-server
if command -v live-server &> /dev/null; then
    echo "📡 使用 live-server 启动..."
    live-server --port=8000 --open=index-modular.html
elif command -v python3 &> /dev/null; then
    echo "🐍 使用 Python3 启动..."
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    echo "🐍 使用 Python 启动..."
    python -m http.server 8000
elif command -v npx &> /dev/null; then
    echo "📦 使用 npx serve 启动..."
    npx serve . -p 8000
else
    echo "❌ 未找到可用的服务器工具"
    echo "请安装以下工具之一："
    echo "  - live-server: npm install -g live-server"
    echo "  - Python 3.x"
    echo "  - Node.js (包含npx)"
    exit 1
fi

echo "🌐 服务器地址: http://localhost:8000"
echo "📱 模块化版本: http://localhost:8000/index-modular.html"
echo "📄 原始版本: http://localhost:8000/index.html"
