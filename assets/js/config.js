/**
 * 引爆数据价值工作坊 - 配置文件
 * 包含所有步骤的配置信息、计时器设置等
 */

// 工作坊配置
const WORKSHOP_CONFIG = {
    // 基本信息
    title: "引爆数据价值：共创工作坊引导页",
    version: "2.0.0",
    
    // 步骤配置
    steps: [
        {
            id: 0,
            title: "欢迎页面",
            section: "开始",
            duration: 0,
            icon: "🚀",
            animation: "bounce-in"
        },
        {
            id: 1,
            title: "开场环节(1/4): 两真一假",
            section: "第一部分 (开场) (25分钟)",
            duration: 15 * 60, // 15分钟
            icon: "🤔",
            animation: "float-animation"
        },
        {
            id: 2,
            title: "开场环节(2/4): 人体光谱 (座位版)",
            section: "第一部分 (开场) (接续)",
            duration: 10 * 60, // 10分钟
            icon: "🧘",
            animation: "pulse-animation"
        },
        {
            id: 3,
            title: "共识环节(3/4): 描绘理想未来",
            section: "第二部分 (共识) (35分钟)",
            duration: 20 * 60, // 20分钟
            icon: "🤝",
            animation: "float-animation"
        },
        {
            id: 4,
            title: "共识环节(4/4): 共创当前问题",
            section: "第二部分 (共识) (接续)",
            duration: 15 * 60, // 15分钟
            icon: "💡",
            animation: "shake-animation"
        },
        {
            id: 5,
            title: "聚焦真问题 - 工具1: 用户旅程图",
            section: "第三部分 (35分钟)",
            duration: 5 * 60, // 5分钟
            icon: "🔍",
            animation: "float-animation"
        },
        {
            id: 6,
            title: "聚焦真问题 (活动)",
            section: "第三部分 (35分钟)",
            duration: 25 * 60, // 25分钟
            icon: "📊",
            animation: "pulse-animation"
        },
        {
            id: 7,
            title: "工具2: 5个为什么 (5 Whys)",
            section: "方法学习",
            duration: 5 * 60, // 5分钟
            icon: "❓",
            animation: "float-animation"
        },
        {
            id: 8,
            title: "工具3: \"我们如何才能...\" (HMW)",
            section: "第四部分 (50分钟)",
            duration: 5 * 60, // 5分钟
            icon: "💭",
            animation: "pulse-animation"
        },
        {
            id: 9,
            title: "共创解决方案 (活动1)",
            section: "第四部分 (接续)",
            duration: 20 * 60, // 20分钟
            icon: "🧠",
            animation: "shake-animation"
        },
        {
            id: 10,
            title: "工具4: \"影响力-可行性\" 矩阵",
            section: "方法学习",
            duration: 5 * 60, // 5分钟
            icon: "📊",
            animation: "pulse-animation"
        },
        {
            id: 11,
            title: "共创解决方案 (活动2)",
            section: "第四部分 (接续)",
            duration: 20 * 60, // 20分钟
            icon: "🎯",
            animation: "float-animation"
        },
        {
            id: 12,
            title: "定义价值与行动",
            section: "第五部分 (30分钟)",
            duration: 30 * 60, // 30分钟
            icon: "🚀",
            animation: "pulse-animation"
        },
        {
            id: 13,
            title: "结论",
            section: "总结",
            duration: 0,
            icon: "🎉",
            animation: "bounce-in"
        }
    ],
    
    // 导航映射
    navigation: {
        "0": { step: 0, label: "开始" },
        "1": { step: 1, label: "1. 开场" },
        "3": { step: 3, label: "2. 共识" },
        "5": { step: 5, label: "3. 问题" },
        "8": { step: 8, label: "4. 方案" },
        "12": { step: 12, label: "5. 行动" },
        "13": { step: 13, label: "总结" }
    },
    
    // 时间配置
    timeSchedule: [
        {
            section: "第一部分",
            title: "开场",
            duration: 25,
            icon: "🚀"
        },
        {
            section: "第二部分", 
            title: "共识",
            duration: 35,
            icon: "🤝"
        },
        {
            section: "第三部分",
            title: "聚焦真问题", 
            duration: 35,
            icon: "❓"
        },
        {
            section: "第四部分",
            title: "共创解决方案",
            duration: 50,
            icon: "✨"
        },
        {
            section: "第五部分",
            title: "定义价值与行动",
            duration: 30,
            icon: "📈"
        }
    ],
    
    // 动画配置
    animations: {
        slideUpDelay: 100, // 每个元素的动画延迟间隔(ms)
        transitionDuration: 500 // 步骤切换动画时长(ms)
    },
    
    // 计时器配置
    timer: {
        warningTime: 60, // 剩余1分钟时警告
        endSound: false, // 是否播放结束提示音
        showNotification: true // 是否显示时间到通知
    }
};

// 工具方法
const WORKSHOP_UTILS = {
    /**
     * 格式化时间显示
     * @param {number} seconds - 秒数
     * @returns {string} 格式化的时间字符串
     */
    formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
    },
    
    /**
     * 根据步骤ID获取步骤配置
     * @param {number} stepId - 步骤ID
     * @returns {Object|null} 步骤配置对象
     */
    getStepConfig(stepId) {
        return WORKSHOP_CONFIG.steps.find(step => step.id === stepId) || null;
    },
    
    /**
     * 获取总时长
     * @returns {number} 总时长（分钟）
     */
    getTotalDuration() {
        return WORKSHOP_CONFIG.timeSchedule.reduce((total, section) => total + section.duration, 0);
    },
    
    /**
     * 验证步骤ID是否有效
     * @param {number} stepId - 步骤ID
     * @returns {boolean} 是否有效
     */
    isValidStep(stepId) {
        return stepId >= 0 && stepId < WORKSHOP_CONFIG.steps.length;
    }
};

// 导出配置到全局作用域
window.WORKSHOP_CONFIG = WORKSHOP_CONFIG;
window.WORKSHOP_UTILS = WORKSHOP_UTILS; 