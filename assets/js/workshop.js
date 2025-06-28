/**
 * 引爆数据价值工作坊 - 主要JavaScript功能
 * 包含导航、计时器、动画等核心功能
 */

// 全局变量
let currentStep = 0;
let globalTimerId = null;

// DOM元素引用
let steps, totalSteps, prevBtn, nextBtn, progressBar, navLinks;

// 导航步骤映射
const navStepMapping = { "0": 0, "1": 1, "3": 3, "5": 5, "8": 8, "12": 12, "13": 13 };

/**
 * 初始化工作坊应用
 */
function initWorkshop() {
    // 获取DOM元素
    steps = document.querySelectorAll('.workshop-step');
    totalSteps = steps.length;
    prevBtn = document.getElementById('prev-btn');
    nextBtn = document.getElementById('next-btn');
    progressBar = document.getElementById('progress-bar');
    navLinks = document.querySelectorAll('#top-nav .nav-link');

    // 绑定事件监听器
    bindEventListeners();
    
    // 显示初始步骤
    showStep(currentStep);
}

/**
 * 绑定所有事件监听器
 */
function bindEventListeners() {
    // 下一步按钮
    nextBtn.addEventListener('click', () => {
        if (currentStep < totalSteps - 1) {
            currentStep++;
            showStep(currentStep);
        }
    });

    // 上一步按钮
    prevBtn.addEventListener('click', () => {
        if (currentStep > 0) {
            currentStep--;
            showStep(currentStep);
        }
    });

    // 导航链接点击
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const step = parseInt(e.target.dataset.step);
            currentStep = navStepMapping[step] !== undefined ? navStepMapping[step] : step;
            showStep(currentStep);
        });
    });

    // 鼠标移动光晕效果
    document.body.addEventListener('mousemove', handleMouseMove);

    // 键盘导航
    document.addEventListener('keydown', handleKeyNavigation);
}

/**
 * 显示指定步骤
 * @param {number} stepIndex - 步骤索引
 */
function showStep(stepIndex) {
    // 隐藏所有步骤
    steps.forEach(step => step.classList.remove('active'));
    
    // 显示目标步骤
    const targetStep = document.getElementById(`step-${stepIndex}`);
    if (targetStep) {
        targetStep.classList.add('active');
        
        // 设置动画延迟
        const animatedElements = targetStep.querySelectorAll('.animate-in');
        animatedElements.forEach((el, index) => {
            el.style.animationDelay = `${100 * (index + 1)}ms`;
        });
    }

    // 更新按钮状态
    updateButtonStates(stepIndex);
    
    // 更新进度条
    updateProgressBar(stepIndex);
    
    // 更新导航状态
    updateNavigation(stepIndex);
    
    // 更新当前步骤显示
    updateStepCounter(stepIndex);
}

/**
 * 更新按钮状态
 * @param {number} stepIndex - 当前步骤索引
 */
function updateButtonStates(stepIndex) {
    prevBtn.disabled = stepIndex === 0;
    
    if (stepIndex === totalSteps - 1) {
        nextBtn.textContent = '完成';
    } else {
        nextBtn.textContent = '下一步 →';
    }
}

/**
 * 更新进度条
 * @param {number} stepIndex - 当前步骤索引
 */
function updateProgressBar(stepIndex) {
    const progressPercentage = (stepIndex / (totalSteps - 1)) * 100;
    progressBar.style.width = `${progressPercentage}%`;
}

/**
 * 更新导航高亮状态
 * @param {number} stepIndex - 当前步骤索引
 */
function updateNavigation(stepIndex) {
    navLinks.forEach(link => {
        link.classList.remove('active');
        const linkStep = parseInt(link.dataset.step);
        
        if ((stepIndex === 0 && linkStep === 0) || // "开始" section
            (stepIndex >= 1 && stepIndex <= 2 && linkStep === 1) || // "开场" section
            (stepIndex >= 3 && stepIndex <= 4 && linkStep === 3) || // "共识" section
            (stepIndex >= 5 && stepIndex <= 7 && linkStep === 5) || // "问题" section
            (stepIndex >= 8 && stepIndex <= 11 && linkStep === 8) || // "方案" section
            (stepIndex === 12 && linkStep === 12) || // "行动" section
            (stepIndex === 13 && linkStep === 13)) { // "总结" section
            link.classList.add('active');
        }
    });
}

/**
 * 更新步骤计数器
 * @param {number} stepIndex - 当前步骤索引
 */
function updateStepCounter(stepIndex) {
    const currentStepElement = document.getElementById('current-step');
    const totalStepsElement = document.getElementById('total-steps');
    
    if (currentStepElement) {
        currentStepElement.textContent = stepIndex + 1;
    }
    if (totalStepsElement) {
        totalStepsElement.textContent = totalSteps;
    }
}

/**
 * 处理鼠标移动事件 - 创建光晕跟随效果
 * @param {MouseEvent} e - 鼠标事件对象
 */
function handleMouseMove(e) {
    const { clientX, clientY } = e;
    const { innerWidth, innerHeight } = window;
    document.body.style.setProperty('--glow-x', `${(clientX / innerWidth) * 100}%`);
    document.body.style.setProperty('--glow-y', `${(clientY / innerHeight) * 100}%`);
}

/**
 * 处理键盘导航
 * @param {KeyboardEvent} e - 键盘事件对象
 */
function handleKeyNavigation(e) {
    // 如果用户正在文本框中输入，不触发导航
    if (document.activeElement.tagName === 'TEXTAREA') {
        return;
    }
    
    if (e.key === 'ArrowRight') {
        nextBtn.click();
    } else if (e.key === 'ArrowLeft') {
        prevBtn.click();
    }
}

/**
 * 启动计时器
 * @param {number} duration - 持续时间（秒）
 * @param {string} elementId - 计时器元素ID
 */
function startTimer(duration, elementId) {
    // 清除之前的计时器
    if (globalTimerId) {
        clearInterval(globalTimerId);
    }
    
    const display = document.querySelector(`#${elementId} .timer-display`);
    const button = document.querySelector(`#${elementId} button`);
    
    if (!display || !button) {
        console.error(`Timer elements not found for ${elementId}`);
        return;
    }
    
    // 禁用按钮
    button.disabled = true;
    button.classList.add('opacity-50');

    let timer = duration;
    let minutes, seconds;
    
    globalTimerId = setInterval(function () {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);
        
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;
        
        display.textContent = minutes + ":" + seconds;
        
        if (--timer < 0) {
            clearInterval(globalTimerId);
            display.textContent = "时间到!";
            display.style.color = "#ef4444"; // 红色提示
            
            // 重新启用按钮
            button.disabled = false;
            button.classList.remove('opacity-50');
            
            // 可选：播放提示音或显示通知
            showTimeUpNotification();
        }
    }, 1000);
}

/**
 * 显示时间到通知
 */
function showTimeUpNotification() {
    // 创建简单的通知提示
    const notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-lg shadow-lg z-50 animate-bounce';
    notification.textContent = '⏰ 时间到！';
    
    document.body.appendChild(notification);
    
    // 3秒后自动移除通知
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 3000);
}

/**
 * 重置计时器
 * @param {string} elementId - 计时器元素ID
 * @param {number} duration - 重置的时间（秒）
 */
function resetTimer(elementId, duration) {
    if (globalTimerId) {
        clearInterval(globalTimerId);
    }
    
    const display = document.querySelector(`#${elementId} .timer-display`);
    const button = document.querySelector(`#${elementId} button`);
    
    if (display && button) {
        const minutes = Math.floor(duration / 60);
        const seconds = duration % 60;
        display.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        display.style.color = ''; // 重置颜色
        
        button.disabled = false;
        button.classList.remove('opacity-50');
    }
}

/**
 * 获取当前步骤信息
 * @returns {Object} 当前步骤的信息
 */
function getCurrentStepInfo() {
    return {
        index: currentStep,
        total: totalSteps,
        element: document.getElementById(`step-${currentStep}`),
        title: document.querySelector(`#step-${currentStep} h3`)?.textContent || '未知步骤'
    };
}

/**
 * 跳转到指定步骤
 * @param {number} stepIndex - 目标步骤索引
 */
function goToStep(stepIndex) {
    if (stepIndex >= 0 && stepIndex < totalSteps) {
        currentStep = stepIndex;
        showStep(currentStep);
    }
}

// 不再自动初始化，等待组件加载完成后手动调用
// document.addEventListener('DOMContentLoaded', initWorkshop);

// 将主要函数暴露到全局作用域，供HTML中的onclick等使用
window.startTimer = startTimer;
window.resetTimer = resetTimer;
window.getCurrentStepInfo = getCurrentStepInfo;
window.goToStep = goToStep; 