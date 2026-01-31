/**
 * Quiz Manager for AI Learning Platform
 * Handles quiz generation and interaction
 */
class QuizManager {
    constructor() {
        this.currentQuiz = null;
        this.userAnswers = [];
        this.init();
    }

    init() {
        console.log('QuizManager initialized');
        this.setupEventListeners();
    }

    setupEventListeners() {
        console.log('Setting up quiz event listeners...');
        
        // Form submission handling
        const quizForm = document.getElementById('quizForm');
        if (quizForm) {
            quizForm.addEventListener('submit', (e) => {
                this.handleFormSubmission(e);
            });
        }

        // Quick start buttons for sample topics
        document.querySelectorAll('.sample-topic').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const topic = e.target.dataset.topic;
                const difficulty = e.target.dataset.difficulty || 'medium';
                document.getElementById('topic').value = topic;
                document.getElementById('difficulty').value = difficulty;
            });
        });
    }

    handleFormSubmission(e) {
        e.preventDefault();
        
        const topicInput = document.getElementById('topic');
        const difficultySelect = document.getElementById('difficulty');
        const questionCountSelect = document.getElementById('questionCount');
        
        if (!topicInput || !difficultySelect || !questionCountSelect) {
            this.showError('Form elements not found. Please refresh the page.');
            return;
        }
        
        const topic = topicInput.value.trim();
        
        if (!topic) {
            this.showError('Please enter a quiz topic.');
            topicInput.focus();
            return;
        }
        
        if (topic.length < 2) {
            this.showError('Please enter a valid topic (at least 2 characters).');
            topicInput.focus();
            return;
        }
        
        // Show loading state
        const submitBtn = e.target.querySelector('button[type="submit"]');
        if (submitBtn) {
            this.setButtonLoading(submitBtn, true, '⏳ Generating...');
        }
        
        // Form is valid, allow natural submission
        console.log('Form submitted with topic:', topic);
    }

    // Helper methods
    setButtonLoading(button, isLoading, text) {
        if (!button) return;
        
        button.disabled = isLoading;
        button.innerHTML = text;
        
        if (isLoading) {
            button.style.opacity = '0.7';
            button.style.cursor = 'not-allowed';
        } else {
            button.style.opacity = '1';
            button.style.cursor = 'pointer';
        }
    }

    showError(message) {
        // Simple alert for errors
        alert('Error: ' + message);
        console.error('Quiz Error:', message);
    }

    showSuccess(message) {
        alert('Success: ' + message);
    }

    escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded - initializing QuizManager');
    window.quizManager = new QuizManager();
});

// Utility function for API calls (if needed for future AJAX implementation)
async function callQuizAPI(topic, numQuestions) {
    try {
        const response = await fetch('/quiz/api/generate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `topic=${encodeURIComponent(topic)}&numQuestions=${numQuestions}`
        });
        
        if (!response.ok) {
            throw new Error('API request failed');
        }
        
        return await response.json();
    } catch (error) {
        console.error('API call failed:', error);
        throw error;
    }
}