/* 🚀 ULTRA-MODERN 2024 JAVASCRIPT - CYBERPUNK ENHANCEMENTS */ 

// 🎨 ULTRA-THEME MANAGER
class UltraThemeManager {
    constructor() {
        this.currentTheme = localStorage.getItem('ultra-theme') || 'cyberpunk';
        this.themes = {
            cyberpunk: {
                name: 'Cyberpunk',
                primary: '#00ff88',
                secondary: '#00d4ff',
                accent: '#8b5cf6'
            },
            neon: {
                name: 'Neon',
                primary: '#ff0080',
                secondary: '#00ff80',
                accent: '#8000ff'
            },
            ultra: {
                name: 'Ultra',
                primary: '#8b5cf6',
                secondary: '#06b6d4',
                accent: '#10b981'
            }
        };
        this.init();
    }

    init() {
        this.applyTheme(this.currentTheme);
        this.createThemeToggle();
        this.setupThemeWatcher();
    }

    applyTheme(themeName) {
        const theme = this.themes[themeName];
        if (!theme) return;

        document.documentElement.setAttribute('data-theme', themeName);
        document.documentElement.style.setProperty('--primary', theme.primary);
        document.documentElement.style.setProperty('--primary-light', this.lightenColor(theme.primary, 20));
        document.documentElement.style.setProperty('--primary-dark', this.darkenColor(theme.primary, 20));
        
        this.updateMetaTheme(theme.primary);
        this.showThemeNotification(theme.name);
    }

    createThemeToggle() {
        const existingToggle = document.getElementById('themeToggle');
        if (existingToggle) existingToggle.remove();

        const toggle = document.createElement('button');
        toggle.id = 'themeToggle';
        toggle.className = 'btn btn-cyber-ultra hover-cyber';
        toggle.innerHTML = '<span>🎨</span>';
        toggle.title = 'Switch Theme';
        toggle.addEventListener('click', () => this.cycleTheme());

        const navActions = document.querySelector('.nav-actions');
        if (navActions) navActions.appendChild(toggle);
    }

    cycleTheme() {
        const themeNames = Object.keys(this.themes);
        const currentIndex = themeNames.indexOf(this.currentTheme);
        const nextIndex = (currentIndex + 1) % themeNames.length;
        const nextTheme = themeNames[nextIndex];
        
        this.currentTheme = nextTheme;
        localStorage.setItem('ultra-theme', nextTheme);
        this.applyTheme(nextTheme);
        this.addThemeTransition();
    }

    addThemeTransition() {
        document.documentElement.style.transition = 'all 0.5s cubic-bezier(0.4, 0, 0.2, 1)';
        setTimeout(() => {
            document.documentElement.style.transition = '';
        }, 500);
    }

    updateMetaTheme(color) {
        const metaTheme = document.querySelector('meta[name="theme-color"]');
        if (metaTheme) metaTheme.content = color;
    }

    showThemeNotification(themeName) {
        const notification = document.createElement('div');
        notification.className = 'toast-cyber';
        notification.innerHTML = `<span>🎨</span> Theme switched to ${themeName} mode`;
        
        document.body.appendChild(notification);
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => notification.remove(), 300);
        }, 2000);
    }

    setupThemeWatcher() {
        if (window.matchMedia) {
            const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
            mediaQuery.addEventListener('change', (e) => {
                if (!localStorage.getItem('ultra-theme')) {
                    this.currentTheme = e.matches ? 'cyberpunk' : 'ultra';
                    this.applyTheme(this.currentTheme);
                }
            });
        }
    }

    lightenColor(color, percent) {
        const num = parseInt(color.replace("#", ""), 16);
        const amt = Math.round(2.55 * percent);
        const R = (num >> 16) + amt;
        const G = (num >> 8 & 0x00FF) + amt;
        const B = (num & 0x0000FF) + amt;
        return "#" + (0x1000000 + 
            (R < 255 ? R < 1 ? 0 : R : 255) * 0x10000 +
            (G < 255 ? G < 1 ? 0 : G : 255) * 0x100 +
            (B < 255 ? B < 1 ? 0 : B : 255))
            .toString(16)
            .slice(1);
    }

    darkenColor(color, percent) {
        const num = parseInt(color.replace("#", ""), 16);
        const amt = Math.round(2.55 * percent);
        const R = (num >> 16) - amt;
        const G = (num >> 8 & 0x00FF) - amt;
        const B = (num & 0x0000FF) - amt;
        return "#" + (0x1000000 +
            (R > 255 ? 255 : R < 0 ? 0 : R) * 0x10000 +
            (G > 255 ? 255 : G < 0 ? 0 : G) * 0x100 +
            (B > 255 ? 255 : B < 0 ? 0 : B))
            .toString(16)
            .slice(1);
    }
}

// 🎭 ULTRA-UTILITIES
class UltraUtils {
    static showLoading(element, text = 'Loading...') {
        if (!element) return;
        element.dataset.originalContent = element.innerHTML;
        element.innerHTML = `
            <div class="loading-cyber">
                <span></span><span></span><span></span>
            </div>
            <span style="margin-left: 8px;">${text}</span>
        `;
        element.disabled = true;
    }

    static hideLoading(element) {
        if (!element) return;
        element.innerHTML = element.dataset.originalContent || '';
        element.disabled = false;
    }

    static showAlert(message, type = 'info', duration = 5000) {
        const alert = document.createElement('div');
        alert.className = `toast-cyber alert-${type}`;
        const icons = { success: '✅', error: '❌', warning: '⚠️', info: 'ℹ️' };
        alert.innerHTML = `
            <span>${icons[type] || icons.info}</span>
            <span>${message}</span>
            <button class="alert-close" onclick="this.parentElement.remove()">×</button>
        `;
        document.body.appendChild(alert);
        setTimeout(() => {
            alert.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => alert.remove(), 300);
        }, duration);
    }

    static showToast(message, type = 'info', duration = 3000) {
        const toast = document.createElement('div');
        toast.className = `toast-cyber toast-${type}`;
        const icons = { success: '🎉', error: '💥', warning: '⚡', info: '💡', cyber: '🤖' };
        toast.innerHTML = `<span>${icons[type] || icons.info}</span><span>${message}</span>`;
        document.body.appendChild(toast);
        setTimeout(() => {
            toast.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    static debounce(func, wait) {
        let timeout;
        return function(...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func(...args), wait);
        };
    }

    static throttle(func, limit) {
        let inThrottle;
        return function(...args) {
            if (!inThrottle) {
                func.apply(this, args);
                inThrottle = true;
                setTimeout(() => (inThrottle = false), limit);
            }
        };
    }

    static addRippleEffect(element) {
        element.addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            ripple.style.cssText = `
                position:absolute;width:${size}px;height:${size}px;
                left:${x}px;top:${y}px;background:rgba(255,255,255,0.3);
                border-radius:50%;transform:scale(0);
                animation:ripple 0.6s linear;pointer-events:none;
            `;
            this.style.position = 'relative';
            this.style.overflow = 'hidden';
            this.appendChild(ripple);
            setTimeout(() => ripple.remove(), 600);
        });
    }

    static addSmoothScroll() {
        document.documentElement.style.scrollBehavior = 'smooth';
    }

    static addKeyboardNavigation() {
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                document.querySelectorAll('.modal-overlay').forEach(m => m.remove());
            }
            if (e.ctrlKey && e.key === 'k') {
                e.preventDefault();
                const s = document.querySelector('input[type="search"], input[placeholder*="search" i]');
                if (s) s.focus();
            }
            if (e.ctrlKey && e.key === '/') {
                e.preventDefault();
                this.showToast('Shortcuts: Ctrl+K (Search), Esc (Close)', 'info');
            }
        });
    }

    static addParticleEffect(container) {
        if (!container) return;
        container.classList.add('particles');
        for (let i = 0; i < 20; i++) {
            const p = document.createElement('div');
            p.style.cssText = `
                position:absolute;width:2px;height:2px;
                background:var(--primary);border-radius:50%;
                pointer-events:none;animation:float ${3 + Math.random() * 2}s ease-in-out infinite;
                left:${Math.random() * 100}%;top:${Math.random() * 100}%;
                animation-delay:${Math.random() * 2}s;
            `;
            container.appendChild(p);
        }
    }

    static addScanLines(container) {
        if (container) container.classList.add('scan-lines');
    }

    static addGridPattern(container) {
        if (container) container.classList.add('grid-pattern');
    }
}

// (Other classes remain unchanged — UltraAnimationController, UltraPerformanceMonitor, UltraApp, ultraAnimations, etc.)
// --- keep your existing definitions exactly as they were ---

// 🚀 INITIALIZE ULTRA APP
document.addEventListener('DOMContentLoaded', () => {
    console.log('main.js: DOM Content Loaded');
    
    // Initialize theme manager
    try {
        window.themeManager = new UltraThemeManager();
        console.log('✅ Theme manager initialized');
    } catch (e) {
        console.error('Theme manager error:', e);
    }
    
    // Show welcome message (optional)
    setTimeout(() => {
        try {
            if (typeof UltraUtils !== 'undefined') {
                UltraUtils.showToast('Welcome to AI Learning Platform! 🚀', 'cyber', 3000);
            }
        } catch (e) {
            console.log('Toast notification skipped');
        }
    }, 1000);
});

// 🎯 EXPORT FOR GLOBAL ACCESS
window.UltraUtils = UltraUtils;
window.Utils = UltraUtils; // Alias for compatibility
window.UltraThemeManager = UltraThemeManager;

/* 🌐 AI CHAT BACKEND COMMUNICATION
   ----------------------------------------------------
   This helper connects your frontend (chat.js, quiz.js)
   to the Spring Boot backend endpoint: /api/chat
   ---------------------------------------------------- */
export async function sendToAI(message) {
    try {
        const response = await fetch("http://localhost:8080/api/chat", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(message)
        });

        if (!response.ok) {
            throw new Error(`Server error: ${response.status}`);
        }

        const text = await response.text();
        return text;
    } catch (error) {
        console.error("AI communication failed:", error);
        UltraUtils.showAlert("⚠️ Could not reach AI server.", "error", 4000);
        return "Error connecting to AI assistant.";
    }
}
