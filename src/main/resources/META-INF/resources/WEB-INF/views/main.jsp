<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) {
        theme = "light";
    }
    String bodyClass = "dark".equals(theme) ? "dark" : "";
    String mainBg = "dark".equals(theme) ? "thynk_dark.png" : "thynk.png";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thynk AI</title>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            min-height: 100vh;
            overflow: hidden;
        }
        
        /* Full screen background */
        .main-container {
            position: relative;
            width: 100vw;
            height: 100vh;
            background-image: url('<%= request.getContextPath() %>/static/images/<%= mainBg %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-color: #e8eaf6; /* Fallback color if image not found */
            display: flex;
            flex-direction: column;
        }
        
        /* Login button - top right */
        .login-btn {
            position: absolute;
            top: 30px;
            right: 40px;
            padding: 12px 35px;
            background: white;
            color: #333;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            z-index: 10;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }
        
        /* Start Now button - center */
        .center-content {
            position: absolute;
            top: 68%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }
        
        .start-btn {
            padding: 18px 50px;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            color: white;
            border: none;
            border-radius: 30px;
            font-size: 20px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 8px 25px rgb(144, 163, 248);
        }
        
        .start-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgb(144, 132, 255);
        }
        
        .start-btn:active {
            transform: translateY(-1px);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .login-btn {
                top: 20px;
                right: 20px;
                padding: 10px 25px;
                font-size: 14px;
            }
            
            .start-btn {
                padding: 15px 40px;
                font-size: 18px;
            }
        }

        /* Dark theme styles driven by session 'theme' */
        body.dark {
            background: #020617;
        }

        body.dark .auth-card {
            background: #020617;
            color: #e5e7eb;
        }

        body.dark .auth-title {
            -webkit-text-fill-color: unset;
            color: #e5e7eb;
        }

        body.dark .auth-subtitle {
            color: #9ca3af;
        }

        body.dark {
            background-image: none;
            background-color: #020617;
            color: #e5e7eb;
        }

        body.dark .navbar {
            background: rgba(15, 23, 42, 0.9);
        }

        body.dark .welcome-card,
        body.dark .feature-box {
            background: rgba(15, 23, 42, 0.95);
            color: #e5e7eb;
        }

        body.dark .welcome-card h1,
        body.dark .welcome-card h2,
        body.dark .feature-box h3 {
            -webkit-text-fill-color: unset;
            color: #e5e7eb;
        }

        body.dark .welcome-card p,
        body.dark .feature-box p {
            color: #cbd5e1;
        }

        /* Reduce Start button glow and shadow for dark theme only */
        body.dark .start-btn {
            box-shadow: 0 3px 8px rgba(99, 102, 241, 0.06);
        }
        body.dark .start-btn:hover {
            box-shadow: 0 4px 10px rgba(99, 102, 241, 0.07);
            transform: translateY(0);
        }
    </style>
</head>
<body class="<%= bodyClass %>">
    <div class="main-container">
        <!-- Login Button - Top Right -->
        <a href="${pageContext.request.contextPath}/login" class="login-btn">
            Login
        </a>
        
        <!-- Start Now Button - Center -->
        <div class="center-content">
            <a href="${pageContext.request.contextPath}/login" class="start-btn">
                Start Now
            </a>
        </div>
    </div>
</body>
</html>
