<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) {
        theme = "light";
    }
    String bodyClass = "dark".equals(theme) ? "dark" : "";
    String dashboardBg = "dark".equals(theme) ? "dark.png" : "light.png";
%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Thynk</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <meta name="theme-color" content="#6366F1">
    <meta name="description" content="Modern AI Learning Platform">
    <style>
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', 'Inter', sans-serif;
            background-image: url('<%= request.getContextPath() %>/static/images/<%= dashboardBg %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
        }
        
        
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .nav-brand h2 {
            font-size: 1.5rem;
            /* match quiz page weight for consistent appearance */
            font-weight: 600;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            color: transparent;
        }
        
        .nav-actions {
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }
        
        .btn-icon {
            background: transparent;
            border: 1px solid #e2e8f0;
            padding: 0.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-primary {
            background: linear-gradient(90deg, #6a85ff, #938bff);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(99, 102, 241, 0.3);
        }
        

        .floating-bg div {
            position: absolute;
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0); }
        }
        
        .float-slow {
            animation-duration: 8s !important;
        }
        
        .float-delayed {
            animation-delay: 2s !important;
        }
        
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        

        .centered-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            gap: 2rem;
        }
        
        .welcome-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .feature-box {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
        }
        
        .feature-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        @keyframes pulse {
            0% { transform: scale(0.8); opacity: 0.5; }
            50% { transform: scale(1.2); opacity: 1; }
            100% { transform: scale(0.8); opacity: 0.5; }
        }

        /* Dark theme styles driven by session 'theme' */
        body.dark {
            background-image: url('<%= request.getContextPath() %>/static/images/<%= dashboardBg %>');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
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
        body.dark .feature-box h3 {
            -webkit-text-fill-color: unset;
            color: #e5e7eb;
        }

        body.dark .welcome-card p,
        body.dark .feature-box p {
            color: #cbd5e1;
        }

        body.dark .nav-brand h2 {
            /* keep the gradient text even in dark mode */
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body class="<%= bodyClass %>">
    <div class="floating-bg">
        <div class="float float-slow" style="position: absolute; top: 10%; left: 10%; font-size: 2rem; opacity: 0.05;">🚀</div>
        <div class="float float-delayed" style="position: absolute; top: 20%; right: 15%; font-size: 1.5rem; opacity: 0.05;">💡</div>
        <div class="float" style="position: absolute; bottom: 20%; left: 20%; font-size: 1.8rem; opacity: 0.05;">🎯</div>
        <div class="float float-slow" style="position: absolute; bottom: 30%; right: 10%; font-size: 1.2rem; opacity: 0.05;">⚡</div>
    </div>

    <nav class="navbar">
        <div class="nav-brand">
            <h2>Thynk - AI</h2>
        </div>
        <div class="nav-actions">
            <form method="post" action="/logout" style="display: inline;">
                <button type="submit" class="btn btn-primary" title="Logout">Logout</button>
            </form>
        </div>
    </nav>

    <div class="container" style="margin-top: 4rem;">
        <div class="centered-container">
            
            <div class="welcome-card">
                <h1 style="font-size: 2rem; font-weight: 700; background: linear-gradient(90deg, #6a85ff, #938bff); -webkit-background-clip: text; background-clip: text; color: transparent;">Welcome back, ${user.firstName}!</h1>
                <p style="color: #64748b; font-size: 1.1rem; margin-bottom: 1rem;">Ready to Thynk with AI?</p>
                <div style="margin-top: 2rem; max-width: 400px; margin-left: auto; margin-right: auto; height: 10px; background: rgba(203, 213, 225, 0.5); border-radius: 10px; overflow: hidden;">
                    <div style="height: 100%; width: 75%; background: linear-gradient(90deg, #6366F1, #8B5CF6); border-radius: 10px;"></div>
                </div>
                <div style="margin-top: 1rem; display: flex; justify-content: center; gap: 0.5rem;">
                    <span style="width: 8px; height: 8px; background: #6366F1; border-radius: 50%; animation: pulse 1.5s infinite;"></span>
                    <span style="width: 8px; height: 8px; background: #8B5CF6; border-radius: 50%; animation: pulse 1.5s infinite 0.2s;"></span>
                    <span style="width: 8px; height: 8px; background: #A78BFA; border-radius: 50%; animation: pulse 1.5s infinite 0.4s;"></span>
                </div>
            </div>

            
            <div class="features-grid">
                
                <div class="feature-box">
                    <div style="font-size: 2rem; margin-bottom: 1rem;"></div>
                    <h3 style="font-size: 1.5rem; font-weight: 600; color: #6366F1; margin-bottom: 1rem;">AI Chat Assistant</h3>
                    <p style="color: #64748b; margin-bottom: 1.5rem;">Get instant answers to your questions and clear your doubts with our convinced AI-powered feedback that adapts to your learning style.</p>
                    <a href="/chat" style="display: inline-block; background: linear-gradient(90deg, #6a85ff, #938bff); color: white; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s ease;">Start Chatting</a>
                </div>

                
                <div class="feature-box">
                    <div style="font-size: 2rem; margin-bottom: 1rem;"></div>
                    <h3 style="font-size: 1.5rem; font-weight: 600; color: #6366F1; margin-bottom: 1rem;">Interactive Quizzes</h3>
                    <p style="color: #64748b; margin-bottom: 1.5rem;">Test your knowledge with AI-generated queries on any topic. Get personalized feedback and track your progress over time.</p>
                    <a href="/quiz" style="display: inline-block; background: linear-gradient(90deg, #6a85ff, #938bff); color: white; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s ease;">Take Quiz</a>
                </div>

                
                <div class="feature-box">
                    <div style="font-size: 2rem; margin-bottom: 1rem;"></div>
                    <h3 style="font-size: 1.5rem; font-weight: 600; color: #6366F1; margin-bottom: 1rem;">Settings & Preferences</h3>
                    <p style="color: #64748b; margin-bottom: 1.5rem;">Customize your learning experience, adjust difficulty levels, and set your learning goals to maximize your progress.</p>
                    <a href="/settings" style="display: inline-block; background: linear-gradient(90deg, #6a85ff, #938bff); color: white; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s ease;">Settings</a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>