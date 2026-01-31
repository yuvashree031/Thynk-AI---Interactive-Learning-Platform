class ChatManager {
    constructor() {
        this.currentTopic = '';
        this.conversationMode = 'learn';
        this.isWaitingForResponse = false;
        this.username = window.USERNAME || 'Student'; // Get username from global variable
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.showWelcomeMessage();
        this.testConnection();
    }

    setupEventListeners() {
        console.log("Setting up event listeners...");
        
        const sendButton = document.getElementById('sendButton');
        if (sendButton) {
            console.log("Send button found");
            sendButton.addEventListener('click', () => this.sendMessage());
        } else {
            console.error("Send button NOT found! Looking for #sendButton");
        }

        const messageInput = document.getElementById('messageInput');
        if (messageInput) {
            console.log("Message input found");
            messageInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    this.sendMessage();
                }
            });

            // Focus on input when page loads
            messageInput.focus();
        } else {
            console.error("Message input NOT found! Looking for #messageInput");
        }

        const topicInput = document.getElementById('topicInput');
        if (topicInput) {
            topicInput.addEventListener('input', (e) => {
                this.currentTopic = e.target.value.trim();
                if (this.currentTopic) {
                    this.conversationMode = 'learn';
                }
            });

            topicInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (this.currentTopic) {
                        this.addMessage('bot', `Great! Let's learn about <strong>${this.currentTopic}</strong>. What would you like to know?`);
                        document.getElementById('messageInput').focus();
                    }
                }
            });
        }

        // Topic buttons
        document.querySelectorAll('.topic-btn').forEach(button => {
            button.addEventListener('click', (e) => {
                this.currentTopic = e.target.dataset.topic;
                document.getElementById('topicInput').value = this.currentTopic;
                this.conversationMode = 'learn';
                this.addMessage('bot', `Great! Let's learn about <strong>${this.currentTopic}</strong>. What would you like to know?`);
                document.getElementById('messageInput').focus();
            });
        });

        // Mode switching
        const learnMode = document.getElementById('learnMode');
        const generalMode = document.getElementById('generalMode');
        
        if (learnMode) learnMode.addEventListener('click', () => this.switchMode('learn'));
        if (generalMode) generalMode.addEventListener('click', () => this.switchMode('general'));

        // Quiz button
        const quizBtn = document.getElementById('quizBtn');
        if (quizBtn) {
            quizBtn.addEventListener('click', () => this.generateQuiz());
        }

        // Clear chat button
        const clearChatBtn = document.getElementById('clearChatBtn');
        if (clearChatBtn) {
            clearChatBtn.addEventListener('click', () => this.clearChat());
        }

        console.log("Event listeners setup complete");
    }

    async testConnection() {
        try {
            console.log("Testing connection to backend...");
            const response = await fetch("/chat/api/test");
            if (response.ok) {
                const result = await response.text();
                console.log("Backend connection test:", result);
            } else {
                console.warn("Backend connection test failed:", response.status);
            }
        } catch (error) {
            console.error("Backend connection test error:", error);
        }
    }

    switchMode(mode) {
        this.conversationMode = mode;
        const learnBtn = document.getElementById('learnMode');
        const generalBtn = document.getElementById('generalMode');
        
        if (mode === 'learn') {
            learnBtn.classList.add('active');
            generalBtn.classList.remove('active');
            this.addMessage('bot', '<strong>Learning Mode Activated</strong><br>I will help you learn specific topics. Please enter a topic above to get started!');
        } else {
            generalBtn.classList.add('active');
            learnBtn.classList.remove('active');
            this.addMessage('bot', '<strong>General Chat Mode Activated</strong><br>Ask me anything!');
        }
    }

    async sendMessage() {
        console.log("sendMessage() called");
        
        if (this.isWaitingForResponse) {
            console.log("⏳ Already waiting for response, ignoring click");
            return;
        }

        const messageInput = document.getElementById('messageInput');
        const message = messageInput.value.trim();

        if (!message) {
            console.log("Empty message, not sending");
            return;
        }

        console.log("User message:", message);
        this.addMessage('user', message);
        messageInput.value = '';

        this.setLoadingState(true);
        this.showTypingIndicator();

        try {
            let fullMessage = message;
            if (this.conversationMode === 'learn' && this.currentTopic) {
                fullMessage = `Topic: ${this.currentTopic}\nQuestion: ${message}`;
                console.log("Learning mode - Full message:", fullMessage);
            }

            console.log("Sending to backend: /chat/api/send");
            console.log("Payload:", JSON.stringify({ message: fullMessage }));

            const response = await fetch("/chat/api/send", {
                method: "POST",
                headers: { 
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                body: JSON.stringify({ message: fullMessage })
            });

            console.log("📡 Response status:", response.status, response.statusText);

            if (!response.ok) {
                let errorDetail = `HTTP ${response.status}`;
                try {
                    const errorText = await response.text();
                    console.error("Error response:", errorText);
                    errorDetail += `: ${errorText}`;
                } catch (e) {
                    errorDetail += `: ${response.statusText}`;
                }
                throw new Error(errorDetail);
            }

            const reply = await response.text();
            console.log("Received reply (first 100 chars):", reply.substring(0, 100) + "...");
            
            this.removeTypingIndicator();
            this.addMessage('bot', reply);
            
        } catch (error) {
            console.error('Chat error:', error);
            this.removeTypingIndicator();
            this.addMessage('bot', `Sorry, I encountered an error while processing your message. Please try again. Error: ${error.message}`);
        } finally {
            this.setLoadingState(false);
        }
    }

    async generateQuiz() {
        if (!this.currentTopic) {
            this.showAlert('Please set a topic first.');
            return;
        }

        try {
            this.setQuizLoadingState(true);
            this.showTypingIndicator();

            const prompt = `Create a 5-question multiple-choice quiz about ${this.currentTopic}. Format it clearly with questions, options, and indicate the correct answers.`;

            console.log("Generating quiz for topic:", this.currentTopic);

            const response = await fetch("/chat/api/send", {
                method: "POST",
                headers: { 
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                body: JSON.stringify({ message: prompt })
            });

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            const quizContent = await response.text();
            this.removeTypingIndicator();
            this.addMessage('bot', `<strong>Quiz on ${this.currentTopic}</strong><br><br>${quizContent}`);
        } catch (error) {
            console.error('Quiz error:', error);
            this.removeTypingIndicator();
            this.addMessage('bot', `Failed to generate quiz. Please try again. Error: ${error.message}`);
        } finally {
            this.setQuizLoadingState(false);
        }
    }

    addMessage(sender, content) {
        const chatMessages = document.getElementById('chatMessages');
        if (!chatMessages) {
            console.error("Chat messages container not found");
            return;
        }

        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}-message`;

        const timestamp = new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
        
        messageDiv.innerHTML = `
            <div class="message-content">
                <div class="message-header">
                    <strong>${sender === 'user' ? 'You' : 'AI Tutor'}</strong>
                    <span class="message-time">${timestamp}</span>
                </div>
                <div class="message-body">${content}</div>
            </div>
        `;

        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTo({ top: chatMessages.scrollHeight, behavior: 'smooth' });
    }

    showTypingIndicator() {
        const chatMessages = document.getElementById('chatMessages');
        if (!chatMessages) return;

        const typingDiv = document.createElement('div');
        typingDiv.className = 'message bot-message typing-indicator';
        typingDiv.id = 'typingIndicator';
        
        typingDiv.innerHTML = `
            <div class="message-content">
                <strong>AI Tutor:</strong> 
                <div class="typing-dots">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>
        `;

        chatMessages.appendChild(typingDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    removeTypingIndicator() {
        const typingIndicator = document.getElementById('typingIndicator');
        if (typingIndicator) typingIndicator.remove();
    }

    setLoadingState(isLoading) {
        this.isWaitingForResponse = isLoading;
        const sendButton = document.getElementById('sendButton');
        const messageInput = document.getElementById('messageInput');

        if (sendButton) {
            if (isLoading) {
                sendButton.innerHTML = '<span class="spinner"></span> Sending...';
                sendButton.disabled = true;
            } else {
                sendButton.textContent = 'Send';
                sendButton.disabled = false;
            }
        }

        if (messageInput) {
            messageInput.disabled = isLoading;
            if (!isLoading) {
                messageInput.focus();
            }
        }
    }

    setQuizLoadingState(isLoading) {
        const quizBtn = document.getElementById('quizBtn');
        if (quizBtn) {
            if (isLoading) {
                quizBtn.innerHTML = '<span class="spinner"></span> Generating...';
                quizBtn.disabled = true;
            } else {
                quizBtn.textContent = 'Generate Quiz';
                quizBtn.disabled = false;
            }
        }
    }

    showWelcomeMessage() {
        this.addMessage('bot', 
            '<strong style="font-size: 1.3rem; color: #6366F1;">AI Tutor</strong><br>' +
            '<span style="font-size: 1.1rem;">Hello <strong>' + this.username + '</strong>! Welcome back to your AI Learning Assistant!</span><br><br>' +
            'I can help you learn topics, chat, and generate quizzes.<br><br>' +
            '<strong>Getting Started:</strong><br>' +
            '1. Enter any Topic, Feel free to ask :)<br>' +
            '2. Ask me questions about the topic.<br>' +
            '3. If you want to generate quiz on a topic, click the Take a Quiz Button above!<br>'
        );
    }

    clearChat() {
        const chatMessages = document.getElementById('chatMessages');
        if (chatMessages) {
            chatMessages.innerHTML = '';
            this.showWelcomeMessage();
        }
    }

    showAlert(message) {
        alert(message);
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log("DOM loaded, initializing ChatManager...");
    try {
        window.chatManager = new ChatManager();
        console.log("ChatManager initialized successfully");
    } catch (error) {
        console.error("Failed to initialize ChatManager:", error);
    }
});

// Global error handler for uncaught errors
window.addEventListener('error', function(e) {
    console.error('Global error:', e.error);
});