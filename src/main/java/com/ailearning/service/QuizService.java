package com.ailearning.service;

import com.ailearning.model.Quiz;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class QuizService {

    @Autowired
    private ChatService chatService;

    public Quiz generateQuiz(String topic, String difficulty) {
        return generateQuiz(topic, difficulty, 5);
    }

    public Quiz generateQuiz(String topic, String difficulty, int numQuestions) {
        String aiResponse = chatService.generateQuizForTopic(topic, difficulty, numQuestions);

        JSONObject json = toJson(aiResponse);
        JSONArray questionsArray = json.getJSONArray("questions");

        Quiz quiz = new Quiz();
        quiz.setTitle("Quiz on " + topic);
        quiz.setTopic(topic);
        quiz.setDifficulty(difficulty);

        List<String> questions = new ArrayList<>();
        List<String> options = new ArrayList<>();
        List<Integer> correctAnswers = new ArrayList<>();

        for (int i = 0; i < questionsArray.length(); i++) {
            JSONObject q = questionsArray.getJSONObject(i);

            QuestionParts parts = sanitizeQuestion(q);

            questions.add(parts.questionText);
            options.add(String.join(",", parts.options));
            correctAnswers.add(parts.correctIndex);
        }

        quiz.setQuestions(questions);
        quiz.setOptions(options);
        quiz.setCorrectAnswers(correctAnswers);

        return quiz;
    }

    private JSONObject toJson(String aiResponse) {
        try {
            return new JSONObject(aiResponse);
        } catch (Exception ignored) {
            int start = aiResponse.indexOf('{');
            int end = aiResponse.lastIndexOf('}');
            if (start >= 0 && end > start) {
                String candidate = aiResponse.substring(start, end + 1);
                return new JSONObject(candidate);
            }
        }
        throw new RuntimeException("Invalid quiz format returned by AI");
    }

    private QuestionParts sanitizeQuestion(JSONObject q) {
        String questionText = q.optString("question", "Untitled Question").trim();

        List<String> opts = new ArrayList<>();
        JSONArray optsArr = q.optJSONArray("options");
        if (optsArr != null) {
            for (int j = 0; j < optsArr.length() && opts.size() < 4; j++) {
                String opt = optsArr.optString(j, "").trim();
                if (!opt.isEmpty()) {
                    opts.add(opt);
                }
            }
        }
        while (opts.size() < 4) {
            opts.add("Option " + (char) ('A' + opts.size()));
        }
        if (opts.size() > 4) {
            opts = opts.subList(0, 4);
        }

        String correctLetter = q.optString("correctAnswer", "A").trim().toUpperCase();
        if (correctLetter.isEmpty()) correctLetter = "A";
        int correctIndex = "ABCD".indexOf(correctLetter.charAt(0));
        if (correctIndex < 0 || correctIndex >= opts.size()) {
            correctIndex = 0;
        }

        return new QuestionParts(questionText, opts, correctIndex);
    }

    private record QuestionParts(String questionText, List<String> options, int correctIndex) {}
}
