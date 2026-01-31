<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
    <title>Quiz Results - Thynk</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-image: url('<%= request.getContextPath() %>/static/images/<%= pageBg %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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

        body.dark .results-card {
            background: #0f172a;
            color: #e5e7eb;
        }

        body.dark .stat-box {
            background: #1e293b;
            border-color: #111827;
        }

        body.dark h1 {
            -webkit-text-fill-color: unset;
            color: #e5e7eb;
        }

        body.dark h3 {
            color: #e5e7eb;
        }

        body.dark .subtitle {
            color: #cbd5e1;
        }

        body.dark label {
            color: #e5e7eb;
        }

        body.dark .score-display {
            color: #e5e7eb;
        }

        body.dark .stat-label {
            color: #cbd5e1;
        }

        body.dark .stat-value {
            color: #e5e7eb;
        }

        body.dark .message {
            color: #cbd5e1;
        }

        body.dark .quiz-info {
            background: #1e293b;
        }

        body.dark .quiz-info-label {
            color: #cbd5e1;
        }

        body.dark .quiz-info-value {
            color: #e5e7eb;
        }

        body.dark .review-title {
            color: #e5e7eb;
        }

        body.dark .question-review {
            background: #1e293b;
            border-color: #334155;
        }

        body.dark .question-review-text {
            color: #e5e7eb;
        }

        body.dark .option-review {
            background: #0f172a;
            border-color: #334155;
        }

        body.dark .option-review-text {
            color: #e5e7eb;
        }

        body.dark .nav-brand h2 {
            -webkit-text-fill-color: unset;
            color: #e5e7eb;
        }

        body.dark .review-question {
            background: #1e293b;
            border-left-color: #334155;
        }

        body.dark .review-question.correct {
            background: #064e3b;
            border-left-color: #10b981;
        }

        body.dark .review-question.incorrect {
            background: #7f1d1d;
            border-left-color: #ef4444;
        }

        body.dark .review-question-number {
            color: #a5b4fc;
        }

        body.dark .badge-correct {
            background: #065f46;
            color: #86efac;
        }

        body.dark .badge-incorrect {
            background: #991b1b;
            color: #fca5a5;
        }

        body.dark .review-question-text {
            color: #e5e7eb;
        }

        body.dark .review-option {
            background: #0f172a;
            border-color: #334155;
            color: #e5e7eb;
        }

        body.dark .review-option.user-answer {
            background: #1e3a5f;
            border-color: #3b82f6;
        }

        body.dark .review-option.correct-answer {
            background: #064e3b;
            border-color: #10b981;
            color: #86efac;
        }

        body.dark .review-option.user-answer.incorrect {
            background: #7f1d1d;
            border-color: #ef4444;
            color: #fca5a5;
        }

        body.dark .option-label {
            color: #a5b4fc;
        }

        body.dark .option-text {
            color: #e5e7eb;
        }

        body.dark .indicator-your-answer {
            background: #1e3a5f;
            color: #93c5fd;
        }

        body.dark .indicator-correct {
            background: #065f46;
            color: #86efac;
        }

        body.dark .indicator-wrong {
            background: #991b1b;
            color: #fca5a5;
        }
        
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .nav-brand h2 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .nav-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .btn {
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 0.95rem;
        }
        
        .btn-primary {
            background: linear-gradient(90deg, #6a85ff, #938bff);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
        }
        
        .btn-outline {
            background: transparent;
            border: 2px solid #6366F1;
            color: #6366F1;
        }
        
        .btn-outline:hover {
            background: #6366F1;
            color: white;
        }
        
        .btn-success {
            background: linear-gradient(90deg, #10b981, #059669);
            color: white;
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        
        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .results-card {
            background: white;
            border-radius: 24px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
            width: 100%;
            animation: slideUp 0.5s ease-out;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .trophy-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
            animation: bounce 1s ease-in-out;
        }
        
        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
        }
        
        .results-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .score-display {
            font-size: 4rem;
            font-weight: 800;
            margin: 2rem 0;
            color: #1f2937;
        }
        
        .score-excellent {
            color: #10b981;
        }
        
        .score-good {
            color: #3b82f6;
        }
        
        .score-average {
            color: #f59e0b;
        }
        
        .score-poor {
            color: #ef4444;
        }
        
        .percentage-bar {
            width: 100%;
            height: 30px;
            background: #e5e7eb;
            border-radius: 15px;
            overflow: hidden;
            margin: 2rem 0;
            position: relative;
        }
        
        .percentage-fill {
            height: 100%;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            border-radius: 15px;
            transition: width 1s ease-out;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .stat-box {
            background: #f9fafb;
            padding: 1.5rem;
            border-radius: 12px;
            border: 2px solid #e5e7eb;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6b7280;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1f2937;
        }
        
        .stat-value-success {
            color: #10b981;
        }
        
        .stat-value-danger {
            color: #ef4444;
        }
        
        .stat-value-primary {
            color: #6366F1;
        }
        
        .message {
            font-size: 1.2rem;
            color: #4b5563;
            margin: 2rem 0;
            line-height: 1.6;
        }
        
        .message strong {
            display: block;
            margin-bottom: 0.5rem;
            font-size: 1.3rem;
        }
        
        .quiz-info {
            background: #f3f4f6;
            padding: 1.5rem;
            border-radius: 12px;
            margin: 2rem 0;
        }
        
        .quiz-info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .quiz-info-item:last-child {
            border-bottom: none;
        }
        
        .quiz-info-label {
            font-weight: 500;
            color: #6b7280;
        }
        
        .quiz-info-value {
            font-weight: 600;
            color: #1f2937;
            text-transform: capitalize;
        }
        
        .review-section {
            margin-top: 3rem;
            text-align: left;
        }
        
        .review-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-align: center;
            color: #1f2937;
        }
        
        .review-question {
            background: #f9fafb;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #e5e7eb;
        }
        
        .review-question.correct {
            border-left-color: #10b981;
            background: #f0fdf4;
        }
        
        .review-question.incorrect {
            border-left-color: #ef4444;
            background: #fef2f2;
        }
        
        .review-question-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }
        
        .review-question-number {
            font-weight: 700;
            font-size: 1.1rem;
            color: #6366F1;
        }
        
        .review-status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .badge-correct {
            background: #d1fae5;
            color: #065f46;
        }
        
        .badge-incorrect {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .review-question-text {
            font-size: 1.05rem;
            font-weight: 500;
            color: #1f2937;
            margin-bottom: 1rem;
            line-height: 1.6;
        }
        
        .review-options {
            margin: 1rem 0;
        }
        
        .review-option {
            padding: 0.75rem 1rem;
            margin: 0.5rem 0;
            border-radius: 8px;
            background: white;
            border: 2px solid #e5e7eb;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .review-option.user-answer {
            border-color: #3b82f6;
            background: #eff6ff;
        }
        
        .review-option.correct-answer {
            border-color: #10b981;
            background: #ecfdf5;
            font-weight: 600;
        }
        
        .review-option.user-answer.incorrect {
            border-color: #ef4444;
            background: #fef2f2;
        }
        
        .option-label {
            font-weight: 700;
            color: #6366F1;
            min-width: 30px;
        }
        
        .option-text {
            flex: 1;
        }
        
        .option-indicator {
            font-size: 0.85rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-weight: 600;
        }
        
        .indicator-your-answer {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .indicator-correct {
            background: #d1fae5;
            color: #065f46;
        }
        
        .indicator-wrong {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 1rem;
            }
            
            .nav-actions {
                width: 100%;
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .results-card {
                padding: 2rem 1.5rem;
            }
            
            .results-title {
                font-size: 2rem;
            }
            
            .score-display {
                font-size: 3rem;
            }
            
            .trophy-icon {
                font-size: 4rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .message {
                font-size: 1.1rem;
            }
            
            .review-title {
                font-size: 1.5rem;
            }
            
            .review-question {
                padding: 1rem;
            }
            
            .review-question-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
            
            .review-option {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
            
            .option-indicator {
                align-self: flex-start;
            }
        }
    </style>
</head>
<body class="<%= bodyClass %>">
    <nav class="navbar">
        <div class="nav-brand">
            <h2>Thynk AI</h2>
        </div>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">Dashboard</a>
            <a href="${pageContext.request.contextPath}/quiz" class="btn btn-primary">New Quiz</a>
        </div>
    </nav>

    <div class="container">
        <div class="results-card">
            <c:set var="percentageValue" value="${percentage}" />
            <c:set var="scoreValue" value="${score}" />
            <c:set var="totalQuestionsValue" value="${totalQuestions}" />
            <c:set var="correctAnswersValue" value="${correctAnswers}" />
            <c:set var="wrongAnswersValue" value="${wrongAnswers}" />
            <c:set var="topicValue" value="${topic}" />
            <c:set var="difficultyValue" value="${difficulty}" />
            
            <h1 class="results-title">Quiz Completed!</h1>
            
            <c:set var="scoreClass" value="score-display" />
            <c:choose>
                <c:when test="${percentageValue >= 80}">
                    <c:set var="scoreClass" value="score-display score-excellent" />
                </c:when>
                <c:when test="${percentageValue >= 60}">
                    <c:set var="scoreClass" value="score-display score-good" />
                </c:when>
                <c:when test="${percentageValue >= 40}">
                    <c:set var="scoreClass" value="score-display score-average" />
                </c:when>
                <c:otherwise>
                    <c:set var="scoreClass" value="score-display score-poor" />
                </c:otherwise>
            </c:choose>
            
            <div class="${scoreClass}">
                ${scoreValue} / ${totalQuestionsValue}
            </div>
            

            <div class="percentage-bar">
                <div class="percentage-fill" data-percentage="${percentageValue}">
                    ${percentageValue}%
                </div>
            </div>
            
        
            <div class="stats-grid">
                <div class="stat-box">
                    <div class="stat-label">Correct</div>
                    <div class="stat-value stat-value-success">${correctAnswersValue}</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">Wrong</div>
                    <div class="stat-value stat-value-danger">${wrongAnswersValue}</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">Score</div>
                    <div class="stat-value stat-value-primary">${percentageValue}%</div>
                </div>
            </div>
            
            <div class="message">
                <c:choose>
                    <c:when test="${percentageValue >= 80}">
                        <strong>Excellent Work!</strong>
                        You've mastered this topic! Keep up the outstanding performance!
                    </c:when>
                    <c:when test="${percentageValue >= 60}">
                        <strong>Good Job!</strong>
                        You have a solid understanding. A bit more practice will make you perfect!
                    </c:when>
                    <c:when test="${percentageValue >= 40}">
                        <strong>Keep Learning!</strong>
                        You're on the right track. Review the material and try again!
                    </c:when>
                    <c:otherwise>
                        <strong>Don't Give Up!</strong>
                        Learning takes time. Review the concepts and practice more!
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="quiz-info">
                <div class="quiz-info-item">
                    <span class="quiz-info-label">Topic:</span>
                    <span class="quiz-info-value">${topicValue}</span>
                </div>
                <div class="quiz-info-item">
                    <span class="quiz-info-label">Difficulty:</span>
                    <span class="quiz-info-value">${difficultyValue}</span>
                </div>
                <div class="quiz-info-item">
                    <span class="quiz-info-label">Total Questions:</span>
                    <span class="quiz-info-value">${totalQuestionsValue}</span>
                </div>
            </div>
            
            <!-- Question Review Section -->
            <c:if test="${not empty questionResults}">
                <div class="review-section">
                    <h2 class="review-title">Answer Review</h2>
                    
                    <c:forEach var="result" items="${questionResults}" varStatus="loop">
                        <div class="review-question ${result.isCorrect ? 'correct' : 'incorrect'}">
                            <div class="review-question-header">
                                <span class="review-question-number">Question ${result.questionNumber}</span>
                                <span class="review-status-badge ${result.isCorrect ? 'badge-correct' : 'badge-incorrect'}">
                                    ${result.isCorrect ? '✓ Correct' : '✗ Incorrect'}
                                </span>
                            </div>
                            
                            <div class="review-question-text">
                                ${result.questionText}
                            </div>
                            
                            <div class="review-options">
                                <c:forEach var="option" items="${result.options}" varStatus="optionLoop">
                                    <c:if test="${optionLoop.index lt 4}">
                                        <c:set var="optionLetter" value="${fn:substring('ABCD', optionLoop.index, optionLoop.index + 1)}" />
                                        <c:set var="isUserAnswer" value="${result.userAnswer eq optionLetter}" />
                                        <c:set var="isCorrectAnswer" value="${result.correctAnswer eq optionLetter}" />
                                        
                                        <div class="review-option 
                                            ${isCorrectAnswer ? 'correct-answer' : ''} 
                                            ${isUserAnswer and not result.isCorrect ? 'user-answer incorrect' : ''}
                                            ${isUserAnswer and result.isCorrect ? 'user-answer' : ''}">
                                            <span class="option-label">${optionLetter}.</span>
                                            <span class="option-text">${option}</span>
                                            
                                            <c:if test="${isCorrectAnswer}">
                                                <span class="option-indicator indicator-correct">✓ Correct Answer</span>
                                            </c:if>
                                            <c:if test="${isUserAnswer and not result.isCorrect}">
                                                <span class="option-indicator indicator-wrong">✗ Your Answer</span>
                                            </c:if>
                                            <c:if test="${isUserAnswer and result.isCorrect}">
                                                <span class="option-indicator indicator-your-answer">✓ Your Answer</span>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <div class="actions">
                <c:url var="retryUrl" value="/quiz/generate">
                    <c:param name="topic" value="${topicValue}" />
                    <c:param name="difficulty" value="${difficultyValue}" />
                    <c:param name="questionCount" value="${totalQuestionsValue}" />
                </c:url>
                
                <a href="${retryUrl}" class="btn btn-outline">
                    Retry Same Topic
                </a>
                <a href="${pageContext.request.contextPath}/quiz" class="btn btn-success">
                    Try New Topic
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                    Back to Dashboard
                </a>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            const percentageFill = document.querySelector('.percentage-fill');
            if (percentageFill) {
                const targetPercentage = percentageFill.getAttribute('data-percentage');
                percentageFill.style.width = '0%';
                
                setTimeout(function() {
                    percentageFill.style.width = targetPercentage + '%';
                }, 100);
            }
        });
    </script>
</body>
</html>