#!/bin/bash

# 📋 待办事项管理工具
# 统一管理 TODO.md 文件的所有操作

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# 配置
TODO_FILE="TODO.md"
BACKUP_FILE="TODO.md.backup"

# 检查TODO文件是否存在
check_todo_file() {
    if [ ! -f "$TODO_FILE" ]; then
        echo -e "${RED}❌ 错误: $TODO_FILE 文件不存在${NC}"
        echo -e "${YELLOW}💡 请先在项目根目录运行此脚本${NC}"
        exit 1
    fi
}

# 创建备份
create_backup() {
    cp "$TODO_FILE" "$BACKUP_FILE"
    echo -e "${GREEN}✅ 已创建备份: $BACKUP_FILE${NC}"
}

# 获取当前时间
get_current_time() {
    date "+%Y-%m-%d %H:%M:%S"
}

# 获取下一个TODO ID
get_next_id() {
    local max_id=0
    
    if [ -f "$TODO_FILE" ]; then
        local ids=$(grep -E "^#### [❌✅🔄] (TODO|DONE)-[0-9]{3}:" "$TODO_FILE" | sed -E 's/.*-(0*([0-9]+)):.*/\2/' | sort -n)
        
        for id in $ids; do
            if [ "$id" -gt "$max_id" ]; then
                max_id=$id
            fi
        done
    fi
    
    echo $((max_id + 1))
}

# 格式化ID为三位数
format_id() {
    printf "%03d" "$1"
}

# 更新统计信息
update_statistics() {
    local total_todos=$(grep -c "^#### ❌ TODO-" "$TODO_FILE" || echo 0)
    local total_done=$(grep -c "^#### ✅ DONE-" "$TODO_FILE" || echo 0)
    local total_tasks=$((total_todos + total_done))
    local progress=0
    
    if [ $total_tasks -gt 0 ]; then
        progress=$(echo "scale=1; $total_done * 100 / $total_tasks" | bc -l 2>/dev/null || echo "0")
    fi
    
    local current_date=$(date "+%Y-%m-%d")
    
    # 更新项目概览
    sed -i "s/\*\*总任务数\*\*: [0-9]*/\*\*总任务数\*\*: $total_tasks/" "$TODO_FILE"
    sed -i "s/\*\*已完成\*\*: [0-9]*/\*\*已完成\*\*: $total_done/" "$TODO_FILE"
    sed -i "s/\*\*进度\*\*: [0-9.]*%/\*\*进度\*\*: ${progress}%/" "$TODO_FILE"
    sed -i "s/\*\*最后更新\*\*: [0-9-]*/\*\*最后更新\*\*: $current_date/" "$TODO_FILE"
    
    echo -e "${GREEN}📊 已更新统计信息: 总任务 $total_tasks, 已完成 $total_done, 进度 ${progress}%${NC}"
}

# 显示帮助信息
show_help() {
    echo -e "${CYAN}📋 待办事项管理工具 - 使用说明${NC}"
    echo ""
    echo -e "${YELLOW}用法:${NC}"
    echo "  $0 <命令> [选项] [参数]"
    echo ""
    echo -e "${YELLOW}命令:${NC}"
    echo "  add [标题] [描述] [优先级]     添加新的待办事项"
    echo "  done <ID>                     标记任务为完成"
    echo "  list [选项]                   查看待办事项"
    echo "  stats                         显示统计信息"
    echo ""
    echo -e "${YELLOW}add 命令选项:${NC}"
    echo "  -t, --title <标题>           任务标题"
    echo "  -d, --description <描述>     任务描述"
    echo "  -p, --priority <优先级>      优先级 (1/high/高, 2/medium/中, 3/low/低)"
    echo ""
    echo -e "${YELLOW}list 命令选项:${NC}"
    echo "  -a, --all                    显示所有任务 (包括已完成)"
    echo "  -d, --done                   只显示已完成任务"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo "  $0 add                                    # 交互式添加"
    echo "  $0 add \"修复Bug\" \"解决登录问题\" high     # 快速添加"
    echo "  $0 done 3                                 # 完成任务 3"
    echo "  $0 list                                   # 查看待办事项"
    echo "  $0 list --all                             # 查看所有任务"
    echo "  $0 stats                                  # 查看统计信息"
}

# ==================== ADD 功能 ====================

# 交互式输入
interactive_add() {
    echo -e "${CYAN}📋 添加新的待办事项${NC}"
    echo -e "${CYAN}==================${NC}"
    echo ""
    
    # 任务标题
    echo -e "${BLUE}📝 请输入任务标题:${NC}"
    read -p "> " title
    if [ -z "$title" ]; then
        echo -e "${RED}❌ 任务标题不能为空${NC}"
        exit 1
    fi
    
    # 任务描述
    echo -e "${BLUE}📄 请输入任务描述:${NC}"
    read -p "> " description
    if [ -z "$description" ]; then
        description="$title"
    fi
    
    # 优先级选择
    echo -e "${BLUE}🎯 请选择优先级:${NC}"
    echo "  1) P1 - 高"
    echo "  2) P2 - 中"
    echo "  3) P3 - 低"
    read -p "> 请输入数字 (1-3) [默认: 2]: " priority_choice
    
    case $priority_choice in
        1) priority="P1 - 高" ;;
        3) priority="P3 - 低" ;;
        *) priority="P2 - 中" ;;
    esac
    
    echo ""
    echo -e "${YELLOW}📋 任务信息确认:${NC}"
    echo -e "  标题: ${GREEN}$title${NC}"
    echo -e "  描述: ${GREEN}$description${NC}"
    echo -e "  优先级: ${GREEN}$priority${NC}"
    echo ""
    
    read -p "确认添加? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏹️  操作已取消${NC}"
        exit 0
    fi
    
    TASK_TITLE="$title"
    TASK_DESCRIPTION="$description"
    TASK_PRIORITY="$priority"
}

# 解析add命令参数
parse_add_args() {
    local title=""
    local description=""
    local priority="P2 - 中"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--title)
                title="$2"
                shift 2
                ;;
            -d|--description)
                description="$2"
                shift 2
                ;;
            -p|--priority)
                case $2 in
                    1|high|高) priority="P1 - 高" ;;
                    2|medium|中) priority="P2 - 中" ;;
                    3|low|低) priority="P3 - 低" ;;
                    *) 
                        echo -e "${RED}❌ 无效的优先级: $2${NC}"
                        exit 1
                        ;;
                esac
                shift 2
                ;;
            *)
                if [ -z "$title" ]; then
                    title="$1"
                elif [ -z "$description" ]; then
                    description="$1"
                else
                    case $1 in
                        1|high|高) priority="P1 - 高" ;;
                        2|medium|中) priority="P2 - 中" ;;
                        3|low|低) priority="P3 - 低" ;;
                    esac
                fi
                shift
                ;;
        esac
    done
    
    if [ -z "$title" ]; then
        return 1  # 需要交互式模式
    fi
    
    if [ -z "$description" ]; then
        description="$title"
    fi
    
    TASK_TITLE="$title"
    TASK_DESCRIPTION="$description"
    TASK_PRIORITY="$priority"
    return 0
}

# 添加待办事项
add_todo() {
    local next_id=$(get_next_id)
    local formatted_id=$(format_id $next_id)
    local current_time=$(get_current_time)
    
    # 构建待办事项内容
    local todo_content="#### ❌ TODO-${formatted_id}: ${TASK_TITLE}
- **状态**: \`❌ TODO\`
- **优先级**: \`${TASK_PRIORITY}\`
- **描述**: ${TASK_DESCRIPTION}
- **创建时间**: \`${current_time}\`
- **完成时间**: \`待完成\`

"
    
    # 找到插入位置
    local insert_line=$(grep -n "<!-- 示例任务 (已注释) -->" "$TODO_FILE" | cut -d: -f1)
    
    if [ -z "$insert_line" ]; then
        insert_line=$(grep -n "## 🎯 待办任务列表" "$TODO_FILE" | cut -d: -f1)
        if [ -n "$insert_line" ]; then
            insert_line=$((insert_line + 2))
        else
            echo -e "${RED}❌ 无法找到插入位置${NC}"
            exit 1
        fi
    fi
    
    # 使用临时文件插入内容
    local temp_file=$(mktemp)
    head -n $((insert_line - 1)) "$TODO_FILE" > "$temp_file"
    echo "$todo_content" >> "$temp_file"
    tail -n +$insert_line "$TODO_FILE" >> "$temp_file"
    
    mv "$temp_file" "$TODO_FILE"
    update_statistics
    
    echo -e "${GREEN}✅ 成功添加待办事项: TODO-${formatted_id}${NC}"
    echo -e "${BLUE}📋 标题: ${TASK_TITLE}${NC}"
    echo -e "${BLUE}🎯 优先级: ${TASK_PRIORITY}${NC}"
    echo -e "${BLUE}📅 创建时间: ${current_time}${NC}"
}

# ==================== DONE 功能 ====================

# 完成任务
complete_task() {
    local task_id="$1"
    
    # 标准化输入格式
    if [[ $task_id =~ ^TODO-([0-9]{3})$ ]]; then
        task_id="${BASH_REMATCH[1]}"
    elif [[ $task_id =~ ^([0-9]{1,3})$ ]]; then
        task_id=$(printf "%03d" "${BASH_REMATCH[1]}")
    else
        echo -e "${RED}❌ 无效的任务编号格式: $1${NC}"
        echo -e "${YELLOW}💡 请使用格式: TODO-001 或 1${NC}"
        exit 1
    fi
    
    # 验证任务是否存在
    if ! grep -q "^#### ❌ TODO-$task_id:" "$TODO_FILE"; then
        echo -e "${RED}❌ 任务 TODO-$task_id 不存在或已完成${NC}"
        exit 1
    fi
    
    local current_time=$(get_current_time)
    local temp_file=$(mktemp)
    local in_target_task="false"
    
    while IFS= read -r line; do
        if [[ $line =~ ^####\ ❌\ TODO-$task_id: ]]; then
            echo "$line" | sed "s/^#### ❌ TODO-/#### ✅ DONE-/" >> "$temp_file"
            in_target_task="true"
        elif [[ $line =~ ^-\ \*\*状态\*\*:\ \`❌\ TODO\`$ ]] && [ "$in_target_task" = "true" ]; then
            echo "- **状态**: \`✅ DONE\`" >> "$temp_file"
        elif [[ $line =~ ^-\ \*\*完成时间\*\*:\ \`待完成\`$ ]] && [ "$in_target_task" = "true" ]; then
            echo "- **完成时间**: \`$current_time\`" >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
        
        if [[ $line =~ ^####\ [❌✅🔄]\ (TODO|DONE)- ]] && [[ ! $line =~ TODO-$task_id ]]; then
            in_target_task="false"
        fi
    done < "$TODO_FILE"
    
    mv "$temp_file" "$TODO_FILE"
    update_statistics
    
    local task_title=$(grep "^#### ✅ DONE-$task_id:" "$TODO_FILE" | sed -E 's/^#### ✅ DONE-[0-9]{3}: (.+)$/\1/')
    
    echo -e "${GREEN}✅ 任务已标记为完成: TODO-$task_id${NC}"
    echo -e "${BLUE}📋 标题: $task_title${NC}"
    echo -e "${BLUE}📅 完成时间: $current_time${NC}"
}

# ==================== LIST 功能 ====================

# 显示统计信息
show_stats() {
    local total_todos=$(grep -c "^#### ❌ TODO-" "$TODO_FILE" 2>/dev/null || echo 0)
    local total_done=$(grep -c "^#### ✅ DONE-" "$TODO_FILE" 2>/dev/null || echo 0)
    local total_tasks=$((total_todos + total_done))
    local progress=0
    
    if [ $total_tasks -gt 0 ]; then
        progress=$(echo "scale=1; $total_done * 100 / $total_tasks" | bc -l 2>/dev/null || echo "0")
    fi
    
    echo -e "${PURPLE}📊 项目统计信息${NC}"
    echo -e "${PURPLE}===============${NC}"
    echo -e "${BLUE}总任务数: ${GREEN}$total_tasks${NC}"
    echo -e "${BLUE}待办事项: ${YELLOW}$total_todos${NC}"
    echo -e "${BLUE}已完成: ${GREEN}$total_done${NC}"
    echo -e "${BLUE}完成进度: ${GREEN}${progress}%${NC}"
    echo ""
}

# 显示待办事项
show_todos() {
    echo -e "${CYAN}📋 待办事项${NC}"
    echo -e "${CYAN}===========${NC}"
    
    local count=0
    while IFS= read -r line; do
        if [[ $line =~ ^####\ ❌\ TODO-([0-9]{3}):\ (.+)$ ]]; then
            local id="${BASH_REMATCH[1]}"
            local title="${BASH_REMATCH[2]}"
            count=$((count + 1))
            echo -e "${YELLOW}TODO-$id: ${GREEN}$title${NC}"
        fi
    done < "$TODO_FILE"
    
    if [ $count -eq 0 ]; then
        echo -e "${GREEN}🎉 没有待办事项！所有任务都已完成。${NC}"
    else
        echo -e "${BLUE}共 $count 个待办事项${NC}"
    fi
    echo ""
}

# 显示已完成任务
show_done() {
    echo -e "${GREEN}✅ 已完成任务${NC}"
    echo -e "${GREEN}============${NC}"
    
    local count=0
    while IFS= read -r line; do
        if [[ $line =~ ^####\ ✅\ DONE-([0-9]{3}):\ (.+)$ ]]; then
            local id="${BASH_REMATCH[1]}"
            local title="${BASH_REMATCH[2]}"
            count=$((count + 1))
            echo -e "${GREEN}DONE-$id: $title${NC}"
        fi
    done < "$TODO_FILE"
    
    if [ $count -eq 0 ]; then
        echo -e "${YELLOW}📝 还没有完成的任务${NC}"
    else
        echo -e "${BLUE}共 $count 个已完成任务${NC}"
    fi
    echo ""
}

# ==================== 主函数 ====================

main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    local command="$1"
    shift
    
    echo -e "${PURPLE}🚀 引爆数据价值工作坊 - 待办事项管理工具${NC}"
    echo ""
    
    check_todo_file
    
    case $command in
        add)
            create_backup
            if parse_add_args "$@"; then
                add_todo
            else
                interactive_add
                add_todo
            fi
            ;;
        done)
            if [ -z "$1" ]; then
                echo -e "${RED}❌ 请指定要完成的任务ID${NC}"
                echo -e "${YELLOW}💡 用法: $0 done <ID>${NC}"
                exit 1
            fi
            create_backup
            complete_task "$1"
            ;;
        list)
            case $1 in
                -a|--all)
                    show_stats
                    show_todos
                    show_done
                    ;;
                -d|--done)
                    show_stats
                    show_done
                    ;;
                *)
                    show_stats
                    show_todos
                    ;;
            esac
            ;;
        stats)
            show_stats
            ;;
        -h|--help|help)
            show_help
            ;;
        *)
            echo -e "${RED}❌ 未知命令: $command${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
    
    if [[ $command != "list" && $command != "stats" ]]; then
        echo ""
        echo -e "${GREEN}🎉 操作完成！${NC}"
        echo -e "${YELLOW}💡 提示: 使用 '$0 list' 查看当前状态${NC}"
    fi
}

main "$@" 