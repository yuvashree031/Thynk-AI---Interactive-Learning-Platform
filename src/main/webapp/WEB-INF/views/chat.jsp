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
    <title>AI Learning Chat - Interactive Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { 
            font-family: 'Poppins', sans-serif; 
            background-image: url('<%= request.getContextPath() %>/static/images/<%= pageBg %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            min-height: 100vh;
            padding: 20px;
        }
        .chat-container { 
            max-width: 1000px; 
            margin: 0 auto; 
            background: white; 
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3); 
            padding: 25px; 
            display: flex; 
            flex-direction: column; 
            height: 90vh;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.25rem;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(8px);
            border-radius: 8px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.25);
            gap: 0.75rem;
            width: 100%;
        }

        body.dark .navbar {
            background: rgba(0,0,0,0.45);
        }

        .nav-brand h2 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
            background: linear-gradient(90deg, #6a85ff, #938bff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-actions {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }

        .btn {
            padding: 0.5rem 0.9rem;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.25s ease;
            font-family: 'Poppins', sans-serif;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }

        .btn-primary {
            background: linear-gradient(90deg, #10b981, #059669);
            color: white;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid rgba(99,102,241,0.9);
            color: rgba(99,102,241,0.95);
            padding: 0.4rem 0.9rem;
            border-radius: 8px;
        }

        .btn-outline:hover { background: rgba(99,102,241,0.08); }
        .chat-messages { 
            flex: 1; 
            overflow-y: auto; 
            padding: 20px; 
            border: 1px solid #e2e8f0; 
            border-radius: 10px; 
            background: #fafafa;
            margin-bottom: 15px;
        }
        .message { 
            margin-bottom: 15px; 
            padding: 12px 16px; 
            border-radius: 12px; 
            max-width: 75%; 
            line-height: 1.6;
            animation: fadeIn 0.3s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .user-message { 
            background: linear-gradient(135deg, #6a85ff, #938bff);
            color: white; 
            margin-left: auto;
            border-bottom-right-radius: 4px;
        }
        .bot-message { 
            background: #f1f3f5; 
            border-left: 4px solid #6366F1;
            color: #333;
            border-bottom-left-radius: 4px;
        }
        .message-content {
            display: flex;
            flex-direction: column;
        }
        .message-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
            font-size: 12px;
        }
        .message-time {
            opacity: 0.7;
            font-size: 11px;
        }
        .message-body {
            font-size: 14px;
            line-height: 1.7;
        }

        .bot-message .message-body h1 {
            font-size: 1.2rem;
            margin: 10px 0 8px;
            color: #4f46e5;
        }

        .bot-message .message-body h2 {
            font-size: 1.08rem;
            margin: 10px 0 8px;
            color: #4f46e5;
        }

        .bot-message .message-body h3 {
            font-size: 1rem;
            margin: 10px 0 6px;
            color: #4f46e5;
        }

        .bot-message .message-body h4,
        .bot-message .message-body h5,
        .bot-message .message-body h6 {
            font-size: 0.95rem;
            margin: 10px 0 6px;
            color: #4f46e5;
        }

        .bot-message .message-body p {
            margin: 8px 0;
        }

        .bot-message .message-body ul,
        .bot-message .message-body ol {
            margin: 8px 0 10px 18px;
            padding: 0;
        }

        .bot-message .message-body li {
            margin: 6px 0;
        }

        .bot-message .message-body table {
            width: 100%;
            border-collapse: collapse;
            margin: 10px 0;
            font-size: 13px;
        }

        .bot-message .message-body th,
        .bot-message .message-body td {
            border: 1px solid #d1d5db;
            padding: 8px;
            vertical-align: top;
        }

        .bot-message .message-body th {
            background: #eef2ff;
            color: #111827;
            font-weight: 700;
        }

        .bot-message .message-body code {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
            background: rgba(99, 102, 241, 0.12);
            padding: 2px 6px;
            border-radius: 6px;
            font-size: 0.92em;
        }

        .bot-message .message-body b {
            font-weight: 700;
        }
        .typing-indicator {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 10px;
        }
        .typing-dots {
            display: flex;
            gap: 4px;
        }
        .typing-dots span {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #6366F1;
            animation: bounce 1.4s infinite ease-in-out;
        }
        .typing-dots span:nth-child(1) { animation-delay: -0.32s; }
        .typing-dots span:nth-child(2) { animation-delay: -0.16s; }
        @keyframes bounce {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
        .input-section {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .pdf-upload-container {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .pdf-upload-container input[type="file"] {
            flex: 1;
        }

        #uploadPdfButton {
            background: linear-gradient(90deg, #6865ff, #a494ff);
            border: none;
            border-radius: 8px;
            color: white;
            padding: 10px 18px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            min-width: 120px;
        }

        #uploadPdfButton:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }

        #uploadPdfButton:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        #pdfUploadStatus {
            font-size: 13px;
            color: #374151;
        }

        body.dark #pdfUploadStatus {
            color: #e5e7eb;
        }
        .input-container { 
            display: flex; 
            gap: 10px;
        }
        input, textarea { 
            flex: 1; 
            padding: 12px; 
            border: 2px solid #e2e8f0; 
            border-radius: 8px; 
            font-family: 'Poppins';
            font-size: 14px;
            transition: border-color 0.3s;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #6366F1;
        }
        textarea {
            resize: none;
            min-height: 60px;
        }
        button#sendButton { 
            background: linear-gradient(90deg, #5145ff, #989aff);
            border: none; 
            border-radius: 8px; 
            color: white; 
            padding: 12px 24px; 
            cursor: pointer; 
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            min-width: 100px;
        }
        button#sendButton:hover:not(:disabled) { 
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(94, 97, 255, 0.76);
        }
        button#sendButton:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .spinner {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s linear infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }
        .chat-messages::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        .chat-messages::-webkit-scrollbar-thumb {
            background: #6366F1;
            border-radius: 10px;
        }
        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #4f46e5;
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

        body.dark .chat-container {
            background: #000000; /* True black for chat interface */
            color: #e5e7eb;
        }

        body.dark .header h2 {
            -webkit-text-fill-color: unset;
            color: #e5e7eb;
        }

        body.dark .mode-buttons h2 {
            -webkit-text-fill-color: unset;
            color: #e5e7eb;
        }

        body.dark .chat-messages {
            background: #1a1a1a; /* Darker background for messages */
            border-color: #333333;
        }

        body.dark .user-message {
            background: linear-gradient(135deg, #333333, #555555); /* Darker gradient for user messages */
        }

        body.dark .bot-message {
            background: #222222; /* Darker background for bot messages */
            border-left-color: #666666;
            color: #e5e7eb;
        }

        body.dark .bot-message .message-body h1,
        body.dark .bot-message .message-body h2,
        body.dark .bot-message .message-body h3,
        body.dark .bot-message .message-body h4,
        body.dark .bot-message .message-body h5,
        body.dark .bot-message .message-body h6 {
            color: #a5b4fc;
        }

        body.dark .bot-message .message-body th {
            background: rgba(99, 102, 241, 0.18);
            color: #e5e7eb;
        }

        body.dark .bot-message .message-body th,
        body.dark .bot-message .message-body td {
            border-color: #374151;
        }

        body.dark .bot-message .message-body code {
            background: rgba(99, 102, 241, 0.22);
            color: #e5e7eb;
        }

        body.dark input,
        body.dark textarea {
            background: #333333;
            border-color: #555555;
            color: #e5e7eb;
        }

        body.dark input:focus,
        body.dark textarea:focus {
            border-color: #888888;
        }

        body.dark button#sendButton {
            background: linear-gradient(90deg, #444444, #666666); /* Darker send button */
        }

        body.dark button#sendButton:hover:not(:disabled) {
            box-shadow: 0 4px 12px rgba(100, 100, 100, 0.4);
        }

        body.dark .chat-messages::-webkit-scrollbar-track {
            background: #333333;
        }

        body.dark .chat-messages::-webkit-scrollbar-thumb {
            background: #666666;
        }

        body.dark .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #888888;
        }
    </style>
</head>
<body class="<%= bodyClass %>">
    <div class="chat-container">
        <nav class="navbar">
            <div class="nav-brand">
                <h2>Thynk Assistant</h2>
            </div>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">Dashboard</a>
                <a href="${pageContext.request.contextPath}/quiz" class="btn btn-primary">Take a Quiz?</a>
            </div>
        </nav>
        
        <div id="chatMessages" class="chat-messages">
            
        </div>
        
        <div class="input-section">
            <form id="pdfUploadForm" class="pdf-upload-container" enctype="multipart/form-data" method="post" action="/chat/upload">
                <input id="pdfFileInput" type="file" name="file" accept=".pdf,application/pdf" />
                <button id="uploadPdfButton" type="submit">Upload This PDF</button>
                <span id="pdfUploadStatus"></span>
            </form>
            <div class="input-container">
                <textarea id="messageInput" placeholder="Type your question or request..." rows="2"></textarea>
                <button id="sendButton">Send</button>
            </div>
        </div>
    </div>


    <script>
        
        window.USERNAME = "${user.username}";
    </script>
    <script src="/static/js/chat.js"></script>
    <script>
        console.log("chat.jsp loaded successfully");
        console.log("chat.js script tag added");
        console.log("Username passed to JS:", window.USERNAME);

        (function () {
            const form = document.getElementById('pdfUploadForm');
            const fileInput = document.getElementById('pdfFileInput');
            const statusEl = document.getElementById('pdfUploadStatus');
            const uploadBtn = document.getElementById('uploadPdfButton');

            if (!form || !fileInput || !statusEl || !uploadBtn) return;

            form.addEventListener('submit', async function (e) {
                e.preventDefault();

                const file = fileInput.files && fileInput.files[0];
                if (!file) {
                    statusEl.textContent = 'Please select a PDF file.';
                    return;
                }

                const isPdf = (file.type && file.type.toLowerCase() === 'application/pdf') || file.name.toLowerCase().endsWith('.pdf');
                if (!isPdf) {
                    statusEl.textContent = 'Only PDF files are allowed.';
                    return;
                }

                const maxBytes = 10 * 1024 * 1024;
                if (file.size > maxBytes) {
                    statusEl.textContent = 'File too large. Max size is 10MB.';
                    return;
                }

                statusEl.textContent = 'Uploading...';
                uploadBtn.disabled = true;

                try {
                    const formData = new FormData();
                    formData.append('file', file);

                    const response = await fetch('/chat/upload', {
                        method: 'POST',
                        body: formData
                    });

                    const data = await response.json();
                    if (!response.ok || !data || data.success !== true) {
                        const msg = (data && data.message) ? data.message : ('Upload failed (HTTP ' + response.status + ')');
                        statusEl.textContent = msg;
                        return;
                    }

                    statusEl.textContent = 'PDF uploaded. You can now ask questions from it.';
                } catch (err) {
                    statusEl.textContent = 'Upload failed: ' + (err && err.message ? err.message : err);
                } finally {
                    uploadBtn.disabled = false;
                }
            });
        })();
    </script>
</body>
</html>
