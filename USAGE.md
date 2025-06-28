# 🚀 引爆数据价值工作坊 - 使用指南

## 📋 待办事项管理

### 统一工具 `todo.sh`

本项目提供了统一的命令行工具来管理待办事项：

```bash
# 基本用法
./todo.sh <命令> [选项] [参数]
```

### 主要命令

#### 1. 添加任务 (`add`)
```bash
# 交互式添加
./todo.sh add

# 快速添加
./todo.sh add "修复Bug" "解决登录问题" high

# 使用选项
./todo.sh add -t "优化性能" -d "提升加载速度" -p 1
```

#### 2. 完成任务 (`done`)
```bash
# 完成指定任务
./todo.sh done 3
./todo.sh done TODO-003
```

#### 3. 查看任务 (`list`)
```bash
# 查看待办事项（默认）
./todo.sh list

# 查看所有任务
./todo.sh list --all

# 只查看已完成任务
./todo.sh list --done
```

#### 4. 查看统计 (`stats`)
```bash
# 显示项目统计信息
./todo.sh stats
```

### 优先级设置

| 输入值 | 优先级 | 说明 |
|--------|--------|------|
| `1`, `high`, `高` | P1 - 高 | 紧急重要任务 |
| `2`, `medium`, `中` | P2 - 中 | 默认优先级 |
| `3`, `low`, `低` | P3 - 低 | 可延后任务 |

### 使用示例

```bash
# 查看当前状态
./todo.sh list

# 添加高优先级任务
./todo.sh add "修复模块化版本Bug" "解决组件加载问题" high

# 完成任务
./todo.sh done 4

# 查看进度
./todo.sh stats
```

---

## 🚀 工作坊网站开发

### 启动开发服务器

```bash
# 一键启动（推荐）
./start.sh

# 手动启动
python3 -m http.server 8000
```

### 构建生产版本

```bash
# 生成单文件版本
node build.js
```

### 文件说明

- **开发使用**: `index.html` (模块化版本，主文件)
- **生产使用**: `index-built.html` (构建后的单文件版本)

### 修改内容

- **样式**: 编辑 `assets/css/main.css`
- **功能**: 编辑 `assets/js/workshop.js`
- **配置**: 编辑 `assets/js/config.js`
- **组件**: 编辑 `components/` 目录下的文件

### 项目结构

```
├── assets/           # 静态资源
│   ├── css/         # 样式文件
│   └── js/          # JavaScript文件
├── components/       # 模块化组件
├── templates/        # 模板文件
├── todo.sh          # 待办事项管理工具
├── start.sh         # 启动脚本
├── build.js         # 构建脚本
├── TODO.md          # 待办事项文件
└── index.html       # 主文件（模块化版本）
```

---

## 🔄 完整工作流程

### 日常开发流程

```bash
# 1. 查看当前任务状态
./todo.sh list

# 2. 启动开发服务器
./start.sh

# 3. 开发过程中添加新任务
./todo.sh add "实现新功能" "添加用户头像上传" medium

# 4. 完成任务后标记
./todo.sh done 5

# 5. 构建生产版本
node build.js

# 6. 查看项目进度
./todo.sh stats
```

### 项目管理最佳实践

1. **每日检查**: 使用 `./todo.sh list` 查看当前状态
2. **及时添加**: 想到新任务立即添加到待办列表
3. **按优先级**: 优先处理P1高优先级任务
4. **及时完成**: 完成任务后立即标记为完成
5. **定期回顾**: 使用 `./todo.sh list --all` 回顾项目进展

---

## 🎨 输出示例

### 添加任务输出
```
🚀 引爆数据价值工作坊 - 待办事项管理工具

✅ 已创建备份: TODO.md.backup
📊 已更新统计信息: 总任务 6, 已完成 2, 进度 33.3%
✅ 成功添加待办事项: TODO-005
📋 标题: 实现新功能
🎯 优先级: P1 - 高
📅 创建时间: 2025-06-28 22:20:00

🎉 操作完成！
💡 提示: 使用 './todo.sh list' 查看当前状态
```

### 查看统计输出
```
🚀 引爆数据价值工作坊 - 待办事项管理工具

📊 项目统计信息
===============
总任务数: 6
待办事项: 3
已完成: 3
完成进度: 50.0%
```

---

## 🛠 故障排除

### 权限问题
```bash
chmod +x todo.sh
chmod +x start.sh
```

### 找不到TODO.md文件
确保在包含TODO.md的项目根目录运行脚本

### 备份恢复
如果操作有误，可以从备份恢复：
```bash
cp TODO.md.backup TODO.md
```

### 依赖问题
确保系统已安装：
- Python 3 (用于开发服务器)
- Node.js (用于构建脚本)
- bc (用于数学计算) 