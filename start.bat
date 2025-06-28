@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: 引爆数据价值工作坊 - 快速启动脚本 (Windows版)
:: 自动检测可用工具并启动本地服务器预览网页

set PORT=8080
set "RED=[31m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "CYAN=[36m"
set "NC=[0m"

echo %CYAN%🚀 引爆数据价值工作坊 - 快速启动脚本%NC%
echo %CYAN%========================================%NC%

:: 检查端口参数
if "%~1" neq "" (
    set /a testport=%~1 2>nul
    if !testport! geq 1024 if !testport! leq 65535 (
        set PORT=%~1
        echo %GREEN%✅ 使用自定义端口: !PORT!%NC%
    ) else (
        echo %RED%❌ 无效端口号: %~1%NC%
        echo %YELLOW%💡 用法: %~nx0 [端口号] ^(1024-65535^)%NC%
        pause
        exit /b 1
    )
)

:: 检查index.html是否存在
if not exist "index.html" (
    echo %RED%❌ 未找到 index.html 文件%NC%
    echo %YELLOW%💡 请确保在包含 index.html 的目录中运行此脚本%NC%
    pause
    exit /b 1
)

echo %GREEN%📁 当前目录: %CD%%NC%
echo %GREEN%📄 发现文件: index.html%NC%
echo.

echo %YELLOW%📍 正在检测可用的服务器工具...%NC%

:: 方法1: 尝试使用 Python 3
python3 --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ 发现 Python 3，使用内置 http.server%NC%
    echo %BLUE%🌐 启动本地服务器: http://localhost:!PORT!%NC%
    echo %YELLOW%💡 按 Ctrl+C 停止服务器%NC%
    echo.
    python3 -m http.server !PORT! --bind 127.0.0.1
    goto :end
)

:: 方法2: 尝试使用 Python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    for /f "tokens=1 delims=." %%i in ("!PYTHON_VERSION!") do set MAJOR_VERSION=%%i
    
    if "!MAJOR_VERSION!" equ "3" (
        echo %GREEN%✅ 发现 Python 3，使用内置 http.server%NC%
        echo %BLUE%🌐 启动本地服务器: http://localhost:!PORT!%NC%
        echo %YELLOW%💡 按 Ctrl+C 停止服务器%NC%
        echo.
        python -m http.server !PORT! --bind 127.0.0.1
    ) else (
        echo %GREEN%✅ 发现 Python 2，使用 SimpleHTTPServer%NC%
        echo %BLUE%🌐 启动本地服务器: http://localhost:!PORT!%NC%
        echo %YELLOW%💡 按 Ctrl+C 停止服务器%NC%
        echo.
        python -m SimpleHTTPServer !PORT!
    )
    goto :end
)

:: 方法3: 尝试使用 Node.js + http-server
npx --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ 发现 Node.js，使用 http-server%NC%
    echo %BLUE%🌐 启动本地服务器: http://localhost:!PORT!%NC%
    echo %YELLOW%💡 按 Ctrl+C 停止服务器%NC%
    echo.
    npx http-server -p !PORT! -a 127.0.0.1 -o
    goto :end
)

:: 方法4: 尝试使用 PHP
php --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ 发现 PHP，使用内置服务器%NC%
    echo %BLUE%🌐 启动本地服务器: http://localhost:!PORT!%NC%
    echo %YELLOW%💡 按 Ctrl+C 停止服务器%NC%
    echo.
    php -S 127.0.0.1:!PORT!
    goto :end
)

:: 如果没有找到任何工具
echo %RED%❌ 未找到可用的服务器工具%NC%
echo %YELLOW%📝 请安装以下任一工具：%NC%
echo    • Python 3: %CYAN%https://www.python.org/downloads/%NC%
echo    • Node.js: %CYAN%https://nodejs.org/%NC%
echo    • PHP: %CYAN%https://www.php.net/downloads%NC%
echo.
echo %BLUE%💡 或者直接在浏览器中打开 file:///%CD:\=/%/index.html%NC%
pause
exit /b 1

:end
pause 