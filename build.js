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
    templateFile: 'index.html',
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
    if (componentLoaderStart !== -1) {
        const componentLoaderEnd = template.indexOf('</script>', componentLoaderStart) + 9;
        if (componentLoaderEnd !== -1) {
            template = template.slice(0, componentLoaderStart) + template.slice(componentLoaderEnd);
            console.log('🗑️  移除组件加载脚本');
        }
    }
    
    // 清理多余的空行
    template = template.replace(/\n\s*\n\s*\n/g, '\n\n');
    
    // 写入输出文件
    writeFile(CONFIG.outputFile, template);
    
    console.log('\n✨ 构建完成！');
    console.log(`📁 输出文件: ${CONFIG.outputFile}`);
    console.log(`📊 文件大小: ${Math.round(template.length / 1024)} KB`);
    console.log(`📏 总行数: ${template.split('\n').length}`);
}

/**
 * 检查启动脚本是否存在
 */
function checkStartScript() {
    if (fs.existsSync('start.sh')) {
        console.log('✅ 启动脚本已存在: start.sh');
        console.log('💡 使用 ./start.sh 启动开发服务器');
    } else {
        console.log('⚠️  未找到启动脚本，请手动启动服务器');
        console.log('💡 推荐命令: python3 -m http.server 8000');
    }
}

/**
 * 显示帮助信息
 */
function showHelp() {
    console.log('🏗️  引爆数据价值工作坊 - 构建工具\n');
    console.log('用法:');
    console.log('  node build.js       构建单文件版本');
    console.log('  node build.js --help 显示此帮助信息');
    console.log('\n输出文件:');
    console.log('  index-built.html    完整的单文件版本');
    console.log('\n功能特性:');
    console.log('  - 内联所有CSS和JavaScript');
    console.log('  - 合并所有组件到单个HTML文件');
    console.log('  - 包含完整的工作坊功能和配置');
}

// 主函数
function main() {
    // 检查帮助参数
    const args = process.argv.slice(2);
    if (args.includes('--help') || args.includes('-h')) {
        showHelp();
        return;
    }
    
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
    
    // 检查启动脚本
    checkStartScript();
    
    console.log('\n🎉 所有任务完成！');
    console.log('\n📝 使用说明:');
    console.log('  - 开发: ./start.sh 启动开发服务器');
    console.log('  - 构建: node build.js 生成单文件版本');
    console.log('  - 生产: 使用 index-built.html');
    console.log('  - 模块化开发: 编辑 components/ 目录下的文件');
}

// 运行
if (require.main === module) {
    main();
}

module.exports = { build, CONFIG }; 