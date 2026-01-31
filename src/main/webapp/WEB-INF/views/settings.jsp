<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) {
        theme = "light";
    }
    String bodyClass = "dark".equals(theme) ? "dark" : "";
%>
<%
    String pageBg = "dark".equals(theme) ? "dark.png" : "light.png";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Settings - Thynk</title>
    <style>
        :root {
            /* Color Palette */
            --primary-gradient: linear-gradient(135deg, #8a8aff 0%, #a5a5ff 100%);
            --primary-color: #8a8aff;
            --primary-dark: #6a6ae6;
            --button-bg: #8a8aff;
            --button-hover: #6a6ae6;
            
            /* Light Theme */
            --light-bg: #ffffff;
            --light-card: #f8f9ff;
            --light-text: #1a1a2e;
            --light-text-secondary: #666687;
            --light-border: #e6e6ff;
            --light-hover: #f0f0ff;
            
            /* Dark Theme */
            --dark-bg: #0a0a14;
            --dark-card: #1a1a2e;
            --dark-text: #f0f0ff;
            --dark-text-secondary: #a0a0cc;
            --dark-border: #2a2a4a;
            --dark-hover: #2a2a4a;
            
            /* UI Variables */
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --radius-xl: 20px;
            --shadow-sm: 0 2px 8px rgba(138, 138, 255, 0.1);
            --shadow-md: 0 4px 16px rgba(138, 138, 255, 0.15);
            --shadow-lg: 0 8px 32px rgba(138, 138, 255, 0.2);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            transition: all 0.3s ease;
        }
        
        body {
            background-image: url('<%= request.getContextPath() %>/static/images/<%= pageBg %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-color: var(--light-bg);
            color: var(--light-text);
            min-height: 100vh;
            line-height: 1.6;
        }
        
        body.dark {
            background-image: url('<%= request.getContextPath() %>/static/images/<%= pageBg %>');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-color: var(--dark-bg);
            color: var(--dark-text);
        }
        
        /* Main Container */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        /* Header */
        .header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .header h1 {
            font-size: 42px;
            font-weight: 800;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }
        
        .header p {
            font-size: 18px;
            color: var(--light-text-secondary);
            max-width: 600px;
            margin: 0 auto;
        }
        
        body.dark .header p {
            color: var(--dark-text-secondary);
        }
        
        /* Settings Layout */
        .settings-layout {
            display: flex;
            flex-direction: column;
            gap: 32px;
        }
        
        /* Section Card */
        .section-card {
            background: var(--light-card);
            border-radius: var(--radius-xl);
            padding: 40px;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--light-border);
        }
        
        body.dark .section-card {
            background: var(--dark-card);
            border-color: var(--dark-border);
        }
        
        .section-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 6px;
            height: 100%;
            background: var(--primary-gradient);
        }
        
        .section-header {
            margin-bottom: 32px;
        }
        
        .section-header h2 {
            font-size: 28px;
            font-weight: 700;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }
        
        .section-header p {
            color: var(--light-text-secondary);
            font-size: 16px;
        }
        
        body.dark .section-header p {
            color: var(--dark-text-secondary);
        }
        
        /* Profile Grid */
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }
        
        .info-item {
            background: var(--light-hover);
            padding: 24px;
            border-radius: var(--radius-lg);
            transition: transform 0.2s ease;
        }
        
        body.dark .info-item {
            background: var(--dark-hover);
        }
        
        .info-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        
        .info-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--light-text-secondary);
            margin-bottom: 8px;
            opacity: 0.8;
        }
        
        body.dark .info-label {
            color: var(--dark-text-secondary);
        }
        
        .info-value {
            font-size: 18px;
            font-weight: 500;
            color: var(--light-text);
        }
        
        body.dark .info-value {
            color: var(--dark-text);
        }
        
        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(138, 138, 255, 0.1);
            color: var(--primary-color);
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
        }
        
        .status-badge::before {
            content: '';
            width: 8px;
            height: 8px;
            background: var(--primary-color);
            border-radius: 50%;
            display: inline-block;
        }
        
        /* Theme Selector */
        .theme-selector {
            display: flex;
            gap: 20px;
            margin-bottom: 32px;
        }
        
        .theme-option {
            flex: 1;
            padding: 28px;
            background: var(--light-hover);
            border-radius: var(--radius-lg);
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        body.dark .theme-option {
            background: var(--dark-hover);
        }
        
        .theme-option:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-color);
        }
        
        .theme-option.active {
            border-color: var(--primary-color);
            background: rgba(138, 138, 255, 0.1);
        }
        
        .theme-icon {
            font-size: 36px;
            margin-bottom: 16px;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .theme-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--light-text);
        }
        
        body.dark .theme-title {
            color: var(--dark-text);
        }
        
        .theme-desc {
            font-size: 14px;
            color: var(--light-text-secondary);
            line-height: 1.5;
        }
        
        body.dark .theme-desc {
            color: var(--dark-text-secondary);
        }
        
        /* About Content */
        .about-content {
            background: rgba(138, 138, 255, 0.05);
            padding: 32px;
            border-radius: var(--radius-lg);
            border-left: 4px solid var(--primary-color);
        }
        
        body.dark .about-content {
            background: rgba(138, 138, 255, 0.1);
        }
        
        .about-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 16px;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .about-text {
            color: var(--light-text-secondary);
            font-size: 16px;
            line-height: 1.8;
        }
        
        body.dark .about-text {
            color: var(--dark-text-secondary);
        }
        
        /* Save Button */
        .btn-save {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 16px 40px;
            background: var(--button-bg);
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-md);
            margin-top: 8px;
        }
        
        .btn-save:hover {
            background: var(--button-hover);
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }
        
        .btn-save:active {
            transform: translateY(0);
        }
        
        /* Form Styles */
        .hidden-radio {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        /* Footer */
        .footer {
            text-align: center;
            margin-top: 64px;
            padding-top: 32px;
            border-top: 1px solid var(--light-border);
            color: var(--light-text-secondary);
            font-size: 14px;
        }
        
        body.dark .footer {
            border-top-color: var(--dark-border);
            color: var(--dark-text-secondary);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                padding: 24px 16px;
            }
            
            .header h1 {
                font-size: 32px;
            }
            
            .section-card {
                padding: 24px;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .theme-selector {
                flex-direction: column;
            }
            
            .btn-save {
                width: 100%;
            }
        }
        
        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .section-card {
            animation: fadeIn 0.5s ease-out forwards;
            opacity: 0;
        }
        
        .section-card:nth-child(1) {
            animation-delay: 0.1s;
        }
        
        .section-card:nth-child(2) {
            animation-delay: 0.2s;
        }
        
        .section-card:nth-child(3) {
            animation-delay: 0.3s;
        }
        
        /* Ripple Effect */
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.4);
            transform: scale(0);
            animation: ripple 0.6s linear;
            pointer-events: none;
        }
        
        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="<%= bodyClass %>">
    <div class="main-container">
        <!-- Header -->
        <div class="header">
            <h1>Account Settings</h1>
            <p>Manage your profile, appearance, and platform preferences</p>
        </div>
        
        <!-- Settings Form -->
        <form action="${pageContext.request.contextPath}/settings" method="post" class="settings-layout" id="settingsForm">
            
            <!-- Profile Information -->
            <div class="section-card">
                <div class="section-header">
                    <h2>Profile Information</h2>
                    <p>Your account details and personal information</p>
                </div>
                
                <div class="profile-grid">
                    <div class="info-item">
                        <span class="info-label">Username</span>
                        <span class="info-value">${sessionScope.user.username}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Full Name</span>
                        <span class="info-value">${sessionScope.user.firstName} ${sessionScope.user.lastName}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Email Address</span>
                        <span class="info-value">${sessionScope.user.email}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Account Role</span>
                        <span class="info-value" style="color: var(--primary-color); font-weight: 600;">${sessionScope.user.role}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Member Since</span>
                        <span class="info-value">${sessionScope.user.createdAt}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Account Status</span>
                        <div class="status-badge">Active</div>
                    </div>
                </div>
            </div>
            
            <!-- Appearance & Theme -->
            <div class="section-card">
                <div class="section-header">
                    <h2>Appearance & Theme</h2>
                    <p>Choose your preferred interface style</p>
                </div>
                
                <div class="theme-selector">
                    <label class="theme-option ${(sessionScope.theme == null || sessionScope.theme == 'light') ? 'active' : ''}">
                        <input type="radio" name="theme" value="light" class="hidden-radio" 
                            <c:if test="${sessionScope.theme == null || sessionScope.theme == 'light'}">checked</c:if>>
                        <div class="theme-icon">
                            <i class="fas fa-sun"></i>
                        </div>
                        <div class="theme-title">Light Mode</div>
                        <div class="theme-desc">Clean and bright interface</div>
                    </label>
                    
                    <label class="theme-option ${sessionScope.theme == 'dark' ? 'active' : ''}">
                        <input type="radio" name="theme" value="dark" class="hidden-radio" 
                            <c:if test="${sessionScope.theme == 'dark'}">checked</c:if>>
                        <div class="theme-icon">
                            <i class="fas fa-moon"></i>
                        </div>
                        <div class="theme-title">Dark Mode</div>
                        <div class="theme-desc">Easy on the eyes in low light</div>
                    </label>
                </div>
                
                <button type="submit" class="btn-save" id="saveBtn">
                    <i class="fas fa-save"></i>
                    Save Appearance Settings
                </button>
            </div>
            
            <!-- About This Platform -->
            <div class="section-card">
                <div class="section-header">
                    <h2>Thynk AI Learning Platform</h2>
                </div>
                
                <div class="about-content">
                    <h3 class="about-title">About Thynk.</h3>
                    <p class="about-text">
                        An AI-based interactive learning web application where students can chat with a chatbot to clear doubts 
                        and generate quizzes using a modern and easy-to-use interface. Students can learn, practice, and test their knowledge in one place.
                    </p>
                </div>
            </div>
        </form>
        
        <!-- Footer -->
        <div class="footer">
            <p>&copy; 2026 AI Learning Platform. All rights reserved.</p>
            <p style="margin-top: 8px; opacity: 0.8;">Yuvashree R</p>
        </div>
    </div>

    <script>
        // Theme selection interaction
        document.querySelectorAll('.theme-option').forEach(option => {
            option.addEventListener('click', function(e) {
                // Remove active class from all options
                document.querySelectorAll('.theme-option').forEach(opt => {
                    opt.classList.remove('active');
                });
                
                // Add active class to clicked option
                this.classList.add('active');
                
                // Check the hidden radio button
                const radio = this.querySelector('input[type="radio"]');
                if (radio) {
                    radio.checked = true;
                }
                
                // Create ripple effect
                createRipple(e, this);
            });
        });
        
        // Save button interaction
        const saveBtn = document.getElementById('saveBtn');
        const settingsForm = document.getElementById('settingsForm');
        
        if (saveBtn && settingsForm) {
            saveBtn.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Create ripple effect
                createRipple(e, this);
                
                // Show loading state
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
                this.disabled = true;
                
                // Get selected theme
                const selectedTheme = settingsForm.querySelector('input[name="theme"]:checked').value;
                
                // Apply theme preview
                if (selectedTheme === 'dark') {
                    document.body.classList.add('dark');
                    document.body.classList.remove('light');
                } else {
                    document.body.classList.add('light');
                    document.body.classList.remove('dark');
                }
                
                // Simulate save operation
                setTimeout(() => {
                    // Show success state
                    this.innerHTML = '<i class="fas fa-check"></i> Settings Saved!';
                    this.style.background = 'var(--primary-dark)';
                    
                    // Submit form after delay
                    setTimeout(() => {
                        settingsForm.submit();
                    }, 1000);
                    
                }, 800);
            });
        }
        
        // Ripple effect function
        function createRipple(event, element) {
            const ripple = document.createElement('span');
            const rect = element.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = event.clientX - rect.left - size / 2;
            const y = event.clientY - rect.top - size / 2;
            
            ripple.classList.add('ripple');
            ripple.style.cssText = `
                width: ${size}px;
                height: ${size}px;
                top: ${y}px;
                left: ${x}px;
            `;
            
            element.style.position = 'relative';
            element.style.overflow = 'hidden';
            
            // Remove existing ripples
            const existingRipples = element.querySelectorAll('.ripple');
            existingRipples.forEach(r => r.remove());
            
            element.appendChild(ripple);
            
            // Remove ripple after animation
            setTimeout(() => {
                ripple.remove();
            }, 600);
        }
        
        // Add hover effects to info items
        document.querySelectorAll('.info-item').forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-4px)';
                this.style.boxShadow = 'var(--shadow-md)';
            });
            
            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = 'none';
            });
        });
        
        // Add keyboard navigation for theme options
        document.addEventListener('keydown', function(e) {
            if (e.key === 'ArrowLeft' || e.key === 'ArrowRight') {
                const options = document.querySelectorAll('.theme-option');
                const activeIndex = Array.from(options).findIndex(opt => 
                    opt.classList.contains('active'));
                
                if (activeIndex !== -1) {
                    let newIndex;
                    if (e.key === 'ArrowLeft') {
                        newIndex = activeIndex > 0 ? activeIndex - 1 : options.length - 1;
                    } else {
                        newIndex = activeIndex < options.length - 1 ? activeIndex + 1 : 0;
                    }
                    
                    options[newIndex].click();
                    options[newIndex].focus();
                }
            }
        });
        
        // Initialize theme preview on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Set initial theme based on session
            const currentTheme = '<%= theme %>';
            if (currentTheme === 'dark') {
                document.body.classList.add('dark');
            }
            
            // Add focus styles for accessibility
            document.querySelectorAll('button, .theme-option').forEach(el => {
                el.addEventListener('focus', function() {
                    this.style.outline = '2px solid var(--primary-color)';
                    this.style.outlineOffset = '2px';
                });
                
                el.addEventListener('blur', function() {
                    this.style.outline = 'none';
                });
            });
        });
    </script>
</body>
</html>