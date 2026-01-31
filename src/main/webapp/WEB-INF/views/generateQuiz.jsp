<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) {
        theme = "light";
    }
    String bodyClass = "dark".equals(theme) ? "dark" : "";
    String pageBg = "dark".equals(theme) ? "dark.png" : "light.png";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Thynk</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background-image: url('<%= request.getContextPath() %>/static/images/<%= pageBg %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
        }

        /* Dark theme styles driven by session 'theme' */
        body.dark {
            background-image: url('<%= request.getContextPath() %>/static/images/<%= pageBg %>');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-color: #020617;
            color: #e5e7eb;
        }

        body.dark .navbar {
            background: rgba(15, 23, 42, 0.9);
        }

        body.dark .quiz-card {
            background: #0f172a;
            color: #e5e7eb;
        }

        body.dark .quiz-title {
            color: #a5b4fc;
        }

        body.dark .quiz-meta {
            color: #cbd5e1;
        }

        body.dark .quiz-meta strong {
            color: #e5e7eb;
        }

        body.dark .question-header {
            color: #e5e7eb;
        }

        body.dark .question-text {
            color: #e5e7eb;
        }

        body.dark .option-content {
            color: #e5e7eb;
        }

        body.dark .option-letter {
            color: #e5e7eb;
        }

        body.dark .option {
            background: #1e293b;
            border-color: #334155;
        }

        body.dark .option:hover {
            background-color: #334155;
        }

        body.dark .button-group {
            border-top-color: #334155;
        }
        
        .container {
            max-width: 750px;
            margin: 2rem auto;
            padding: 20px;
        }
        
        .quiz-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            padding: 3rem;
            margin-bottom: 20px;
        }
        
        .quiz-title {
            text-align: center;
            color: #667eea;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }
        
        .quiz-meta {
            text-align: center;
            color: #666;
            font-size: 1rem;
            margin-bottom: 2.5rem;
            line-height: 1.8;
        }
        
        .quiz-meta strong {
            color: #333;
            font-weight: 600;
        }
        
        .question {
            margin-bottom: 2.5rem;
            padding: 0;
            border: none;
            background-color: transparent;
        }
        
        .question-header {
            font-size: 1rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .question-text {
            font-size: 1rem;
            color: #333;
            margin-bottom: 1.2rem;
            line-height: 1.6;
        }
        
        .options {
            margin-left: 0;
        }
        
        .option {
            margin: 0.8rem 0;
            padding: 1rem 1.2rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            background: #fafafa;
            display: flex;
            align-items: center;
        }
        
        .option:hover {
            background-color: #f3f4f6;
            border-color: #667eea;
        }
        
        .option input[type="radio"] {
            margin-right: 12px;
            width: 18px;
            height: 18px;
            cursor: pointer;
            flex-shrink: 0;
        }
        
        .option-content {
            cursor: pointer;
            flex: 1;
            font-size: 0.95rem;
            color: #333;
        }
        
        .option-letter {
            font-weight: 700;
            color: #333;
            margin-right: 8px;
        }
        
        .btn {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 0.7rem 2rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            background: #5568d3;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-outline {
            background: white;
            border: 2px solid #667eea;
            color: #667eea;
        }
        
        .btn-outline:hover {
            background: #f0f4ff;
        }
        
        .button-group {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 2.5rem;
            padding-top: 2rem;
            border-top: 2px solid #f0f0f0;
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
            margin: 0;
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .nav-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .nav-btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 0.95rem;
            border: none;
            cursor: pointer;
        }
        
        .nav-btn-outline {
            background: transparent;
            border: 1px solid #e2e8f0;
            color: #6366F1;
        }
        
        .nav-btn-outline:hover {
            background: #f8f9fa;
            border-color: #6366F1;
        }
        
        .nav-btn-primary {
            background: linear-gradient(90deg, #6a85ff, #938bff);
            color: white;
        }
        
        .nav-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(99, 102, 241, 0.3);
        }
        
        .feedback {
            margin-top: 5px;
            font-weight: 500;
            display: none;
            color: #dc3545;
        }
        
        .loader {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #4a6cf7;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
            display: inline-block;
            vertical-align: middle;
            margin-left: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .error-message {
            color: #dc3545;
            margin: 1rem 0;
            padding: 10px;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
        }
    </style>
</head>
<body class="<%= bodyClass %>">
    <nav class="navbar">
        <div class="nav-brand">
            <h2>Thynk AI</h2>
        </div>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-btn nav-btn-outline">Dashboard</a>
            <a href="${pageContext.request.contextPath}/quiz" class="nav-btn nav-btn-outline">New Quiz</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-btn nav-btn-primary">Logout</a>
        </div>
    </nav>
    
    <div class="container">
        <div class="quiz-card">
            <h1 class="quiz-title">Generated Quiz</h1>
            <div class="quiz-meta">
                <strong>Topic:</strong> ${quiz.topic} | <strong>Difficulty:</strong> ${quiz.difficulty} | <strong>Questions:</strong> ${quiz.questions.size()}
            </div>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                ${error}
            </div>
        </c:if>
        
        <form id="quizForm" action="${pageContext.request.contextPath}/quiz/submit" method="post">
            <input type="hidden" name="quizId" value="${quiz.id}">
            
            <c:forEach items="${quiz.questions}" var="question" varStatus="qStatus">
                <div class="question">
                    <div class="question-header">Question ${qStatus.index + 1}</div>
                    <div class="question-text">${question}</div>
                    <div class="options">
                        <c:set var="options" value="${quiz.options[qStatus.index].split(',')}" />
                        <c:forEach items="${options}" var="option" varStatus="oStatus">
                            <c:if test="${oStatus.index lt 4}">
                                <c:set var="optionLetter" value="${['A', 'B', 'C', 'D'][oStatus.index]}" />
                                <label class="option" for="q${qStatus.index}_${oStatus.index}">
                                    <input type="radio" 
                                           id="q${qStatus.index}_${oStatus.index}" 
                                           name="q${qStatus.index}" 
                                           value="${oStatus.index}">
                                    <span class="option-content">
                                        <span class="option-letter">${optionLetter}.</span> ${option}
                                    </span>
                                </label>
                            </c:if>
                        </c:forEach>
                        <div class="feedback" id="feedback${qStatus.index}"></div>
                    </div>
                </div>
            </c:forEach>
            
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/quiz" class="btn btn-outline">Back to Quiz Generator</a>
                <button type="button" id="submitBtn" class="btn">Submit Quiz</button>
            </div>
        </form>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('quizForm');
            const submitBtn = document.getElementById('submitBtn');
            
            submitBtn.addEventListener('click', function() {
                
                const questions = document.querySelectorAll('.question');
                let allAnswered = true;
                
                questions.forEach((question, index) => {
                    const selectedOption = question.querySelector('input[type="radio"]:checked');
                    const feedback = document.getElementById('feedback' + index);
                    
                    if (!selectedOption) {
                        allAnswered = false;
                        if (feedback) {
                            feedback.textContent = 'Please select an answer';
                            feedback.style.color = 'red';
                            feedback.style.display = 'block';
                        }
                    } else {
                        if (feedback) {
                            feedback.style.display = 'none';
                        }
                    }
                });
                
                if (!allAnswered) {
                    alert('Please answer all questions before submitting.');
                    return;
                }
                
                if (confirm('Are you sure you want to submit the quiz?')) {
            
                    form.submit();
                }
            });
        });
    </script>
</body>
</html>