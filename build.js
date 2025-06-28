#!/usr/bin/env node

/**
 * 构建脚本 - 将模块化版本合并为单文件版本
 * 用法: node build.js
 */

const fs = require('fs');
const path = require('path');

// 配置
const CONFIG = {
    outputFile: 'index-built.html',
    templateFile: 'index-modular.html',
    components: [
        { placeholder: 'background-placeholder', file: 'components/background.html' },
        { placeholder: 'header-placeholder', file: 'components/header.html' },
        { placeholder: 'welcome-step-placeholder', file: 'components/steps/step-welcome.html' },
        { placeholder: 'workshop-steps-placeholder', file: 'components/workshop-steps.html' },
        { placeholder: 'conclusion-step-placeholder', file: 'components/steps/step-conclusion.html' },
        { placeholder: 'footer-placeholder', file: 'components/footer.html' }
    ],
    assets: [
        { type: 'css', file: 'assets/css/main.css' },
        { type: 'js', file: 'assets/js/config.js' },
        { type: 'js', file: 'assets/js/workshop.js' }
    ]
};

/**
 * 读取文件内容
 */
function readFile(filePath) {
    try {
        return fs.readFileSync(filePath, 'utf8');
    } catch (error) {
        console.error(`Error reading file ${filePath}:`, error.message);
        return '';
    }
}

/**
 * 写入文件
 */
function writeFile(filePath, content) {
    try {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`✅ Successfully created ${filePath}`);
    } catch (error) {
        console.error(`❌ Error writing file ${filePath}:`, error.message);
    }
}

/**
 * 构建单文件版本
 */
function build() {
    console.log('🔨 开始构建单文件版本...\n');
    
    // 读取模板文件
    let template = readFile(CONFIG.templateFile);
    if (!template) {
        console.error('❌ 无法读取模板文件');
        return;
    }
    
    // 内联CSS和JS资源
    CONFIG.assets.forEach(asset => {
        const content = readFile(asset.file);
        if (content) {
            if (asset.type === 'css') {
                // 替换CSS链接为内联样式
                const cssLink = `<link rel="stylesheet" href="${asset.file}">`;
                const inlineCSS = `<style>\n${content}\n    </style>`;
                template = template.replace(cssLink, inlineCSS);
                console.log(`📄 内联CSS: ${asset.file}`);
            } else if (asset.type === 'js') {
                // 在script标签前添加内联JS
                const scriptTag = `<script src="${asset.file}"></script>`;
                if (template.includes(scriptTag)) {
                    template = template.replace(scriptTag, '');
                }
                // 在主要JS文件前插入
                const mainScriptIndex = template.indexOf('<script src="assets/js/workshop.js">');
                if (mainScriptIndex !== -1 && asset.file !== 'assets/js/workshop.js') {
                    const inlineJS = `    <script>\n${content}\n    </script>\n    `;
                    template = template.slice(0, mainScriptIndex) + inlineJS + template.slice(mainScriptIndex);
                    console.log(`📄 内联JS: ${asset.file}`);
                } else if (asset.file === 'assets/js/workshop.js') {
                    // 替换主要JS文件
                    const jsScript = `<script src="${asset.file}"></script>`;
                    const inlineJS = `<script>\n${content}\n    </script>`;
                    template = template.replace(jsScript, inlineJS);
                    console.log(`📄 内联JS: ${asset.file}`);
                }
            }
        }
    });
    
    // 替换组件占位符
    CONFIG.components.forEach(component => {
        const content = readFile(component.file);
        if (content) {
            const placeholder = `<div id="${component.placeholder}"></div>`;
            template = template.replace(placeholder, content.trim());
            console.log(`🧩 插入组件: ${component.file}`);
        }
    });
    
    // 移除组件加载脚本
    const componentLoaderStart = template.indexOf('<!-- 组件加载脚本 -->');
    const componentLoaderEnd = template.indexOf('</script>', componentLoaderStart) + 9;
    if (componentLoaderStart !== -1 && componentLoaderEnd !== -1) {
        template = template.slice(0, componentLoaderStart) + template.slice(componentLoaderEnd);
        console.log('🗑️  移除组件加载脚本');
    }
    
    // 清理多余的空行
    template = template.replace(/\n\s*\n\s*\n/g, '\n\n');
    
    // 写入输出文件
    writeFile(CONFIG.outputFile, template);
    
    console.log('\n✨ 构建完成！');
    console.log(`📁 输出文件: ${CONFIG.outputFile}`);
    console.log(`📊 文件大小: ${Math.round(template.length / 1024)} KB`);
}

/**
 * 创建开发服务器启动脚本
 */
function createDevScript() {
    const devScript = `#!/bin/bash

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
`;
    
    writeFile('dev-server.sh', devScript);
    
    // 设置执行权限
    try {
        fs.chmodSync('dev-server.sh', '755');
        console.log('🔧 创建开发服务器脚本: dev-server.sh');
    } catch (error) {
        console.log('⚠️  无法设置执行权限，请手动执行: chmod +x dev-server.sh');
    }
}

// 主函数
function main() {
    console.log('🏗️  引爆数据价值工作坊 - 构建工具\n');
    
    // 检查必要文件是否存在
    const requiredFiles = [CONFIG.templateFile, ...CONFIG.components.map(c => c.file), ...CONFIG.assets.map(a => a.file)];
    const missingFiles = requiredFiles.filter(file => !fs.existsSync(file));
    
    if (missingFiles.length > 0) {
        console.error('❌ 缺少必要文件:');
        missingFiles.forEach(file => console.error(`   - ${file}`));
        return;
    }
    
    // 执行构建
    build();
    
    // 创建开发脚本
    createDevScript();
    
    console.log('\n🎉 所有任务完成！');
    console.log('\n📝 使用说明:');
    console.log('  - 开发: ./dev-server.sh 或 node build.js');
    console.log('  - 生产: 使用 index-built.html');
    console.log('  - 模块化开发: 编辑 components/ 目录下的文件');
}

// 运行
if (require.main === module) {
    main();
}

module.exports = { build, CONFIG }; 