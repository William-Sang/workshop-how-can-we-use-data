# 🚀 快速使用指南

## 启动开发服务器

```bash
# 一键启动（推荐）
./start.sh

# 手动启动
python3 -m http.server 8000
```

## 构建生产版本

```bash
# 生成单文件版本
node build.js
```

## 文件说明

- **开发使用**: `index.html` (模块化版本，主文件)
- **生产使用**: `index-built.html` (构建后的单文件版本)

## 修改内容

- **样式**: 编辑 `assets/css/main.css`
- **功能**: 编辑 `assets/js/workshop.js`
- **配置**: 编辑 `assets/js/config.js`
- **组件**: 编辑 `components/` 目录下的文件

## 项目结构

```
├── assets/           # 静态资源
├── components/       # 模块化组件
├── templates/        # 模板文件
├── start.sh         # 启动脚本
├── build.js         # 构建脚本
└── index.html       # 主文件（模块化版本）
```

更多详细信息请查看 [README-modular.md](README-modular.md) 