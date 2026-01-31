<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) {
        theme = "light";
    }
    String bodyClass = "dark".equals(theme) ? "dark" : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Thynk</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', 'Inter', sans-serif;
            background: linear-gradient(135deg, #6a85ff 0%, #938bff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .auth-container {
            width: 100%;
            max-width: 480px;
        }

        .auth-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 40px 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: fadeIn 0.5s ease-out;
        }

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

        .auth-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .auth-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .auth-subtitle {
            color: #666;
            font-size: 15px;
            line-height: 1.5;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            animation: slideIn 0.3s ease-out;
            font-size: 14px;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-error {
            background-color: #fee2e2;
            border-left: 4px solid #ef4444;
            color: #991b1b;
        }

        .alert-success {
            background-color: #dcfce7;
            border-left: 4px solid #22c55e;
            color: #166534;
        }

        .alert-icon {
            margin-right: 10px;
            font-size: 18px;
        }

        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
            flex: 1;
        }

        .form-group-full {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #ffffff;
        }

        .form-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-input::placeholder {
            color: #9ca3af;
        }

        .btn-primary {
            width: 100%;
            padding: 14px 20px;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            font-family: inherit;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .auth-footer {
            margin-top: 25px;
            text-align: center;
        }

        .auth-footer p {
            color: #6b7280;
            font-size: 14px;
        }

        .auth-footer a {
            color: #667eea;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .auth-footer a:hover {
            color: #764ba2;
            text-decoration: underline;
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

        body.dark .form-label {
            color: #e5e7eb;
        }

        body.dark .form-input {
            background: #1e293b;
            border-color: #334155;
            color: #e5e7eb;
        }

        body.dark .form-input::placeholder {
            color: #94a3b8;
        }

        body.dark .form-input:focus {
            border-color: #6366F1;
        }

        body.dark .alert-error {
            background-color: #7f1d1d;
            color: #fca5a5;
        }

        body.dark .alert-success {
            background-color: #14532d;
            color: #86efac;
        }

        body.dark .auth-footer a {
            color: #a5b4fc;
        }

        body.dark .auth-footer p {
            color: #cbd5e1;
        }

        @media (max-width: 640px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body class="<%= bodyClass %>">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1 class="auth-title">Join Thynk</h1>
                <p class="auth-subtitle">Create your account and start your personalized learning journey</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <span class="alert-icon">⚠️</span>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <span class="alert-icon">✅</span>
                    <span>${success}</span>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/signup">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName" class="form-label">First Name</label>
                        <input 
                            type="text" 
                            id="firstName" 
                            name="firstName" 
                            class="form-input"
                            placeholder="Enter your first name" 
                            required 
                            autocomplete="given-name"
                        >
                    </div>

                    <div class="form-group">
                        <label for="lastName" class="form-label">Last Name</label>
                        <input 
                            type="text" 
                            id="lastName" 
                            name="lastName" 
                            class="form-input"
                            placeholder="Enter your last name" 
                            required 
                            autocomplete="family-name"
                        >
                    </div>
                </div>

                <div class="form-group-full">
                    <label for="username" class="form-label">Username</label>
                    <input 
                        type="text" 
                        id="username" 
                        name="username" 
                        class="form-input"
                        placeholder="Choose a unique username" 
                        required 
                        autocomplete="username"
                    >
                </div>

                <div class="form-group-full">
                    <label for="email" class="form-label">Email Address</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-input"
                        placeholder="Enter your email address" 
                        required 
                        autocomplete="email"
                    >
                </div>

                <div class="form-group-full">
                    <label for="password" class="form-label">Password</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-input"
                        placeholder="Create a strong password" 
                        required 
                        autocomplete="new-password"
                    >
                </div>

                <button type="submit" class="btn-primary">
                    Create Account
                </button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
