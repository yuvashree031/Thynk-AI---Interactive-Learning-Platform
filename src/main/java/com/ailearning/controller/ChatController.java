package com.ailearning.controller;

import com.ailearning.model.User;
import com.ailearning.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/chat")
public class ChatController {

    private static final String SESSION_PDF_TEXT_KEY = "chatPdfExtractedText";
    private static final String SESSION_PDF_S3_URL_KEY = "chatPdfS3Url";
    private static final long MAX_PDF_SIZE_BYTES = 10L * 1024L * 1024L;

    @Autowired
    private ChatService chatService;

    @GetMapping
    public String showChatPage(jakarta.servlet.http.HttpSession session, org.springframework.ui.Model model) {
        System.out.println("=== CHAT PAGE REQUESTED ===");
        
        Object user = session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("user", user);
        return "chat";
    }
    
    @PostMapping("/api/send")
    @ResponseBody
    public String chat(@RequestBody Map<String, String> request, HttpSession session) {
        try {
            System.out.println("=== /chat/api/send ENDPOINT HIT ===");
            System.out.println("Received request: " + request);
            
            String userMessage = request.get("message");
            if (userMessage == null || userMessage.trim().isEmpty()) {
                return "Error: Message is empty";
            }
            
            System.out.println("User message: " + userMessage);
            
            User tempUser = new User();
            tempUser.setId(1L);

            String extractedPdfText = (String) session.getAttribute(SESSION_PDF_TEXT_KEY);
            var chatHistory = (extractedPdfText == null || extractedPdfText.isBlank())
                    ? chatService.generalChat(tempUser, userMessage)
                    : chatService.generalChatWithContext(tempUser, userMessage, extractedPdfText);
            String response = chatHistory.getBotResponse();
            System.out.println("Sending response back to frontend: " + response.substring(0, Math.min(100, response.length())) + "...");
            return response;
            
        } catch (Exception e) {
            System.err.println("ERROR in /chat/api/send: " + e.getMessage());
            e.printStackTrace();
            return "Sorry, I encountered an error: " + e.getMessage();
        }
    }

    @PostMapping("/upload")
    @ResponseBody
    public Map<String, Object> uploadPdf(@RequestParam("file") MultipartFile file, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            System.out.println("=== /chat/upload ENDPOINT HIT ===");

            if (file == null || file.isEmpty()) {
                result.put("success", false);
                result.put("message", "No file uploaded");
                return result;
            }

            if (file.getSize() > MAX_PDF_SIZE_BYTES) {
                result.put("success", false);
                result.put("message", "File too large. Max size is 10MB");
                return result;
            }

            String originalFilename = file.getOriginalFilename();
            String contentType = file.getContentType();
            boolean isPdf = (contentType != null && contentType.equalsIgnoreCase("application/pdf"));
            if (!isPdf && originalFilename != null) {
                isPdf = originalFilename.toLowerCase().endsWith(".pdf");
            }

            if (!isPdf) {
                result.put("success", false);
                result.put("message", "Only PDF files are allowed");
                return result;
            }

            String sessionId = session.getId();
            String objectKey = chatService.buildPdfObjectKey(originalFilename, sessionId);
            String s3Url = chatService.uploadPdfToS3(file, objectKey);

            String extractedText = chatService.extractTextFromPdf(file);
            if (extractedText == null) {
                extractedText = "";
            }

            int maxCharsToStore = 20000;
            String textToStore = extractedText;
            if (textToStore.length() > maxCharsToStore) {
                textToStore = textToStore.substring(0, maxCharsToStore);
            }

            session.setAttribute(SESSION_PDF_TEXT_KEY, textToStore);
            session.setAttribute(SESSION_PDF_S3_URL_KEY, s3Url);

            result.put("success", true);
            result.put("message", "PDF uploaded and processed successfully");
            result.put("s3Url", s3Url);
            result.put("extractedTextLength", textToStore.length());
            return result;

        } catch (Exception e) {
            System.err.println("ERROR in /chat/upload: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Failed to upload PDF: " + e.getMessage());
            return result;
        }
    }
    
    @PostMapping("/api/send-json")
    @ResponseBody
    public String chatJson(@RequestBody Map<String, String> request) {
        try {
            System.out.println("=== /chat/api/send-json ENDPOINT HIT ===");
            String userMessage = request.get("message");
            System.out.println("Received JSON message: " + userMessage);
            
            User tempUser = new User();
            tempUser.setId(1L);
            
            var chatHistory = chatService.generalChat(tempUser, userMessage);
            return chatHistory.getBotResponse();
            
        } catch (Exception e) {
            System.err.println("ERROR in /chat/api/send-json: " + e.getMessage());
            e.printStackTrace();
            return "Sorry, I encountered an error: " + e.getMessage();
        }
    }
    
    @PostMapping("/api/learn")
    @ResponseBody
    public String learnTopic(@RequestParam String topic, @RequestParam String message) {
        try {
            System.out.println("=== /chat/api/learn ENDPOINT HIT ===");
            System.out.println("Topic: " + topic + ", Message: " + message);
            
            User tempUser = new User();
            tempUser.setId(1L);
            
            var chatHistory = chatService.saveChat(tempUser, message, topic);
            return chatHistory.getBotResponse();
            
        } catch (Exception e) {
            System.err.println("ERROR in /chat/api/learn: " + e.getMessage());
            e.printStackTrace();
            return "Error in learning mode: " + e.getMessage();
        }
    }
    
    @PostMapping("/api/quiz")
    @ResponseBody
    public String generateQuiz(@RequestParam String topic,
                              @RequestParam(defaultValue = "medium") String difficulty,
                              @RequestParam(defaultValue = "5") int numQuestions) {
        try {
            System.out.println("=== /chat/api/quiz ENDPOINT HIT ===");
            System.out.println("Generating quiz for topic: " + topic + " difficulty: " + difficulty + " num: " + numQuestions);
            return chatService.generateQuizForTopic(topic, difficulty, numQuestions);
        } catch (Exception e) {
            System.err.println("ERROR in /chat/api/quiz: " + e.getMessage());
            e.printStackTrace();
            return "Error generating quiz: " + e.getMessage();
        }
    }
    
    @GetMapping("/api/test")
    @ResponseBody
    public String testGroqAPI() {
        try {
            System.out.println("=== /chat/api/test ENDPOINT HIT ===");
            User tempUser = new User();
            tempUser.setId(1L);
            var result = chatService.generalChat(tempUser, "Hello, are you working?");
            return "Groq API is working! Response: " + result.getBotResponse();
        } catch (Exception e) {
            System.err.println("ERROR in /chat/api/test: " + e.getMessage());
            e.printStackTrace();
            return "Groq API Test Failed: " + e.getMessage();
        }
    }
    
    @GetMapping("/api/ping")
    @ResponseBody
    public String ping() {
        return "Server is running! Timestamp: " + System.currentTimeMillis();
    }
    
    @PostMapping("/api/echo")
    @ResponseBody
    public String echo(@RequestBody Map<String, String> request) {
        System.out.println("=== /chat/api/echo ENDPOINT HIT ===");
        System.out.println("Received: " + request);
        return "Received your message: " + request.get("message");
    }
}