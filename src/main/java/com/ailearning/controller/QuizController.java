package com.ailearning.controller;

import com.ailearning.model.Quiz;
import com.ailearning.service.QuizService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/quiz")
public class QuizController {

    @Autowired
    private QuizService quizService;

    @GetMapping("")
    public String showQuizPage(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("pageTitle", "AI Learning Platform - Quiz");
        return "quiz";
    }

    @PostMapping("/generate")
    public String generateQuiz(
            @RequestParam String topic,
            @RequestParam(required = false, defaultValue = "medium") String difficulty,
            @RequestParam(required = false, defaultValue = "5") int questionCount,
            Model model,
            HttpSession session) {
        
        try {
            if (topic == null || topic.trim().isEmpty()) {
                model.addAttribute("error", "Topic cannot be empty");
                return "redirect:/quiz";
            }
            
            if (questionCount < 1 || questionCount > 10) {
                questionCount = 5;
            }
            
            Quiz quiz = quizService.generateQuiz(topic, difficulty, questionCount);
            
            session.setAttribute("currentQuiz", quiz);
            
            model.addAttribute("quiz", quiz);
            model.addAttribute("pageTitle", "Quiz: " + topic);
            return "generateQuiz";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error generating quiz: " + e.getMessage());
            return "redirect:/quiz";
        }
    }
    
    @PostMapping("/submit")
    public String submitQuiz(
            @RequestParam(required = false) Long quizId,
            HttpSession session,
            Model model,
            @RequestParam java.util.Map<String, String> allParams) {
        
        try {
            Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
            
            if (quiz == null) {
                model.addAttribute("error", "Quiz not found. Please generate a new quiz.");
                return "redirect:/quiz";
            }
            
            int totalQuestions = quiz.getQuestions().size();
            int correctAnswers = 0;
            int wrongAnswers = 0;
            
            java.util.List<java.util.Map<String, Object>> questionResults = new java.util.ArrayList<>();
            
            for (int i = 0; i < totalQuestions; i++) {
                String userAnswerParam = allParams.get("q" + i);
                
                if (userAnswerParam != null) {
                    int userAnswer = Integer.parseInt(userAnswerParam);
                    int correctAnswer = quiz.getCorrectAnswers().get(i);
                    boolean isCorrect = userAnswer == correctAnswer;
                    
                    if (isCorrect) {
                        correctAnswers++;
                    } else {
                        wrongAnswers++;
                    }
                    
                    java.util.Map<String, Object> questionResult = new java.util.HashMap<>();
                    questionResult.put("questionNumber", i + 1);
                    questionResult.put("questionText", quiz.getQuestions().get(i));
                    
                    String[] optionsArray = quiz.getOptions().get(i).split(",");
                    questionResult.put("options", java.util.Arrays.asList(optionsArray));
                    
                    String userAnswerLetter = String.valueOf((char) ('A' + userAnswer));
                    String correctAnswerLetter = String.valueOf((char) ('A' + correctAnswer));
                    
                    questionResult.put("userAnswer", userAnswerLetter);
                    questionResult.put("correctAnswer", correctAnswerLetter);
                    questionResult.put("isCorrect", isCorrect);
                    
                    questionResults.add(questionResult);
                }
            }
            
            int percentage = (int) Math.round((correctAnswers * 100.0) / totalQuestions);
            
            model.addAttribute("score", correctAnswers);
            model.addAttribute("totalQuestions", totalQuestions);
            model.addAttribute("correctAnswers", correctAnswers);
            model.addAttribute("wrongAnswers", wrongAnswers);
            model.addAttribute("percentage", percentage);
            model.addAttribute("topic", quiz.getTopic());
            model.addAttribute("difficulty", quiz.getDifficulty());
            model.addAttribute("questionResults", questionResults);
            
            session.removeAttribute("currentQuiz");
            
            return "score";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error submitting quiz: " + e.getMessage());
            return "redirect:/quiz";
        }
    }
}
