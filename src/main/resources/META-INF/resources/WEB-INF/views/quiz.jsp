<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Quiz - AI Learning Platform</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

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
        }
        
        body.dark {
            background-image: url('<%= request.getContextPath() %>/static/images/<%= pageBg %>');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-color: #020617;
            color: #e5e7eb;
        }
        
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        body.dark .navbar {
            background: rgba(15, 23, 42, 0.9);
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
            padding: 0.5rem 1rem;
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
            border: 1px solid #6366F1;
            color: #6366F1;
        }
        
        .btn-outline:hover {
            background: #6366F1;
            color: white;
        }
        
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        body.dark .card {
            background: rgba(15, 23, 42, 0.95);
            color: #e5e7eb;
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

        body.dark input,
        body.dark select {
            background: #1e293b;
            border-color: #334155;
            color: #e5e7eb;
        }

        body.dark input::placeholder {
            color: #94a3b8;
        }

        body.dark input:focus,
        body.dark select:focus {
            border-color: #6366F1;
        }
        
        h1 {
            font-size: 2.2rem;
            text-align: center;
            font-weight: 700;
            margin-bottom: 1rem;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        h3 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #333;
        }
        
        .subtitle {
            text-align: center;
            color: #555;
            font-size: 1rem;
            line-height: 1.6;
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            display: block;
            color: #444;
            font-size: 0.95rem;
        }
        
        input,
        select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        
        input:focus,
        select:focus {
            outline: none;
            border-color: #6366F1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        
        input::placeholder {
            color: #999;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .submit-container {
            margin-top: 1.5rem;
            text-align: center;
        }
        
        .submit-container .btn-primary {
            min-width: 200px;
            padding: 0.75rem 2rem;
            font-size: 1rem;
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
            
            .container {
                margin: 1rem auto;
            }
            
            .card {
                padding: 1.5rem;
            }
            
            h1 {
                font-size: 1.8rem;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="<%= bodyClass %>">
    <nav class="navbar">
        <div class="nav-brand">
            <h2>Thynk - AI</h2>
        </div>
        <div class="nav-actions">
            <a href="<%=request.getContextPath()%>/dashboard" class="btn btn-outline">Dashboard</a>
            <a href="<%=request.getContextPath()%>/chat" class="btn btn-outline">Chat</a>
            <form method="post" action="<%=request.getContextPath()%>/logout" style="display:inline;">
                <button type="submit" class="btn btn-primary">Logout</button>
            </form>
        </div>
    </nav>

    <div class="container">
        <div class="card">
            <h1>AI Generated Quizzes</h1>
            <p class="subtitle">Test your Knowledge with Thynk.</p>
        </div>

        <div class="card">
            <h3>Create a New Quiz</h3>
            <form id="quizForm" action="${pageContext.request.contextPath}/quiz/generate" method="post" onsubmit="return validateForm()">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="topic">Topic</label>
                        <input 
                            type="text" 
                            id="topic" 
                            name="topic" 
                            placeholder="Enter a Topic" 
                            required
                            maxlength="100"
                        />
                    </div>
                    
                    <div class="form-group">
                        <label for="difficulty">Difficulty</label>
                        <select id="difficulty" name="difficulty" required>
                            <option value="easy">Easy</option>
                            <option value="medium" selected>Medium</option>
                            <option value="hard">Hard</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="questionCount">Number of Questions</label>
                        <select id="questionCount" name="questionCount" required>
                            <option value="5">5 Questions</option>
                            <option value="10" selected>10 Questions</option>
                            <option value="15">15 Questions</option>
                        </select>
                    </div>
                </div>

                <div class="submit-container">
                    <button type="submit" class="btn btn-primary">
                        Generate Quiz
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div id="quizResults" class="card" style="display: none;">
        <div id="quizContainer">
            <!-- Quiz will be loaded here -->
        </div>
        <div id="quizScore" style="margin-top: 20px; display: none;">
            <h3>Your Score: <span id="score">0</span>/<span id="total">0</span></h3>
            <button id="retryBtn" class="btn btn-outline" style="margin-top: 10px;">Try Again</button>
        </div>
    </div>

    <script>
        function validateForm() {
            const topic = document.getElementById('topic').value.trim();
            if (topic.length < 2) {
                alert('Please enter a valid topic (at least 2 characters)');
                document.getElementById('topic').focus();
                return false;
            }
            return true;
        }
    </script>
    
    <style>
        .question {
            margin-bottom: 20px;
            padding: 15px;
            border-radius: 8px;
            background-color: #f8f9fa;
        }
        
        .options {
            margin-top: 10px;
            margin-left: 20px;
        }
        
        .option {
            margin: 8px 0;
        }
        
        .option input[type="radio"] {
            margin-right: 10px;
        }
        
        .feedback {
            margin-top: 5px;
            font-weight: 500;
        }
        
        .loader {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #6a85ff;
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
        
        .error {
            color: #dc3545;
            font-weight: 500;
        }
    </style>
</body>
</html>