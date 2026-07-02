package com.ailearning.service;

import com.ailearning.model.ChatHistory;
import com.ailearning.model.User;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.List;
import java.util.Scanner;

@Service
public class ChatService {

    private final FirestoreService firestoreService;

    private final PdfService pdfService;

    private final S3Client s3Client;

    public ChatService(FirestoreService firestoreService, PdfService pdfService, S3Client s3Client) {
        this.firestoreService = firestoreService;
        this.pdfService = pdfService;
        this.s3Client = s3Client;
    }

    @Value("${perplexity.api.key}")
    private String apiKey;

    @Value("${perplexity.api.url}")
    private String apiUrl;

    @Value("${perplexity.api.model}")
    private String model;

    @Value("${aws.region}")
    private String awsRegion;

    @Value("${aws.bucketName}")
    private String awsBucketName;

    public ChatHistory saveChat(User user, String userMessage, String topic) {
        String botResponse = formatAiResponseAsHtml(callPerplexityAPI(userMessage, topic));

        ChatHistory chat = new ChatHistory();
        chat.setUser(user);
        chat.setUserMessage(userMessage);
        chat.setBotResponse(botResponse);
        chat.setTopic(topic);

        try {
            return firestoreService.saveChatHistory(user, chat);
        } catch (Exception e) {
            throw new RuntimeException("Failed to save chat history to Firebase: " + e.getMessage(), e);
        }
    }

    public String uploadPdfToS3(MultipartFile file, String objectKey) {
        try {
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(awsBucketName)
                    .key(objectKey)
                    .contentType("application/pdf")
                    .build();

            s3Client.putObject(putObjectRequest, RequestBody.fromBytes(file.getBytes()));
            return "https://" + awsBucketName + ".s3." + awsRegion + ".amazonaws.com/" + objectKey;
        } catch (IOException e) {
            throw new RuntimeException("Failed to read uploaded file: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new RuntimeException("Failed to upload PDF to S3: " + e.getMessage(), e);
        }
    }

    public String extractTextFromPdf(MultipartFile file) {
        try {
            return pdfService.extractText(file);
        } catch (Exception e) {
            throw new RuntimeException("Failed to extract text from PDF: " + e.getMessage(), e);
        }
    }

    public String buildPdfObjectKey(String originalFilename, String sessionId) {
        String safeName = (originalFilename == null || originalFilename.isBlank()) ? "document.pdf" : originalFilename;
        safeName = safeName.replaceAll("[^a-zA-Z0-9._-]", "_");
        return "chat-pdfs/" + sessionId + "/" + Instant.now().toEpochMilli() + "_" + safeName;
    }

    private String buildPromptWithPdfContext(String userMessage, String extractedPdfText) {
        if (extractedPdfText == null || extractedPdfText.isBlank()) {
            return userMessage;
        }

        String trimmed = extractedPdfText;
        int maxChars = 20000;
        if (trimmed.length() > maxChars) {
            trimmed = trimmed.substring(0, maxChars);
        }

        return "You are an AI learning assistant. You have been given extracted text from a PDF. " +
                "Use it as context to summarize or answer questions about the document. " +
                "If the question is unrelated to the document, answer normally.\n\n" +
                "PDF TEXT (EXTRACTED):\n" +
                trimmed +
                "\n\nUSER QUESTION:\n" +
                userMessage;
    }

    public ChatHistory generalChat(User user, String userMessage) {
        return saveChat(user, userMessage, "General");
    }

    public ChatHistory generalChatWithContext(User user, String userMessage, String extractedPdfText) {
        String promptForAi = buildPromptWithPdfContext(userMessage, extractedPdfText);
        String botResponse = formatAiResponseAsHtml(callPerplexityAPI(promptForAi, "General"));

        ChatHistory chat = new ChatHistory();
        chat.setUser(user);
        chat.setUserMessage(userMessage);
        chat.setBotResponse(botResponse);
        chat.setTopic("General");

        try {
            return firestoreService.saveChatHistory(user, chat);
        } catch (Exception e) {
            throw new RuntimeException("Failed to save chat history to Firebase: " + e.getMessage(), e);
        }
    }

    public String generateQuizForTopic(String topic, String difficulty, int numQuestions) {
        String prompt = """
                Generate a multiple-choice quiz about %s with %d questions.
                Difficulty: %s.
                Respond ONLY with valid JSON matching this schema (no extra text):
                {
                  "questions": [
                    {
                      "question": "string",
                      "options": ["A", "B", "C", "D"],
                      "correctAnswer": "A"
                    }
                  ]
                }
                Ensure options are plain text, do not prefix with letters, and correctAnswer is one of A/B/C/D.
                """.formatted(topic, numQuestions, difficulty);
        return callPerplexityAPI(prompt, "Quiz");
    }

    private String formatAiResponseAsHtml(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }

        String text = raw.replace("\r\n", "\n").replace("\r", "\n");
        text = escapeHtml(text);

        String[] lines = text.split("\n", -1);
        StringBuilder out = new StringBuilder();

        boolean inUl = false;
        boolean inOl = false;
        boolean inTable = false;
        boolean tableHasHeader = false;

        java.util.ArrayList<String[]> tableRows = new java.util.ArrayList<>();
        java.util.ArrayList<String> paragraphLines = new java.util.ArrayList<>();

        for (int i = 0; i < lines.length; i++) {
            String trimmed = lines[i].trim();

            if (!inTable && isPotentialTableRow(trimmed) && i + 1 < lines.length && isTableSeparator(lines[i + 1].trim())) {
                flushParagraph(out, paragraphLines);
                if (inUl) {
                    out.append("</ul>");
                    inUl = false;
                }
                if (inOl) {
                    out.append("</ol>");
                    inOl = false;
                }

                inTable = true;
                tableHasHeader = true;
                tableRows.clear();
                tableRows.add(splitTableRow(trimmed));
                i++;
                continue;
            }

            if (inTable) {
                if (trimmed.isEmpty()) {
                    out.append(renderTable(tableRows, tableHasHeader));
                    inTable = false;
                    tableHasHeader = false;
                    tableRows.clear();
                    continue;
                }

                if (!isPotentialTableRow(trimmed)) {
                    out.append(renderTable(tableRows, tableHasHeader));
                    inTable = false;
                    tableHasHeader = false;
                    tableRows.clear();
                    i--;
                    continue;
                }

                tableRows.add(splitTableRow(trimmed));
                continue;
            }

            if (trimmed.isEmpty()) {
                flushParagraph(out, paragraphLines);
                if (inUl) {
                    out.append("</ul>");
                    inUl = false;
                }
                if (inOl) {
                    out.append("</ol>");
                    inOl = false;
                }
                continue;
            }

            int hLevel = headingLevel(trimmed);
            if (hLevel > 0) {
                flushParagraph(out, paragraphLines);
                if (inUl) {
                    out.append("</ul>");
                    inUl = false;
                }
                if (inOl) {
                    out.append("</ol>");
                    inOl = false;
                }

                String content = trimmed.substring(hLevel).trim();
                out.append("<h").append(hLevel).append(">")
                        .append(applyInlineFormatting(content))
                        .append("</h").append(hLevel).append(">");
                continue;
            }

            String bullet = parseBulletItem(trimmed);
            if (bullet != null) {
                flushParagraph(out, paragraphLines);
                if (inOl) {
                    out.append("</ol>");
                    inOl = false;
                }
                if (!inUl) {
                    out.append("<ul>");
                    inUl = true;
                }
                out.append("<li>").append(applyInlineFormatting(bullet)).append("</li>");
                continue;
            }

            String numbered = parseNumberedItem(trimmed);
            if (numbered != null) {
                flushParagraph(out, paragraphLines);
                if (inUl) {
                    out.append("</ul>");
                    inUl = false;
                }
                if (!inOl) {
                    out.append("<ol>");
                    inOl = true;
                }
                out.append("<li>").append(applyInlineFormatting(numbered)).append("</li>");
                continue;
            }

            if (inUl) {
                out.append("</ul>");
                inUl = false;
            }
            if (inOl) {
                out.append("</ol>");
                inOl = false;
            }

            paragraphLines.add(trimmed);
        }

        if (inTable) {
            out.append(renderTable(tableRows, tableHasHeader));
        }

        flushParagraph(out, paragraphLines);

        if (inUl) {
            out.append("</ul>");
        }
        if (inOl) {
            out.append("</ol>");
        }

        return out.toString();
    }

    private void flushParagraph(StringBuilder out, java.util.List<String> paragraphLines) {
        if (paragraphLines == null || paragraphLines.isEmpty()) {
            return;
        }

        out.append("<p>");
        for (int j = 0; j < paragraphLines.size(); j++) {
            if (j > 0) {
                out.append("<br/>");
            }
            out.append(applyInlineFormatting(paragraphLines.get(j)));
        }
        out.append("</p>");
        paragraphLines.clear();
    }

    private String applyInlineFormatting(String text) {
        if (text == null || text.isBlank()) {
            return "";
        }

        String out = text;
        out = out.replaceAll("\\*\\*(.+?)\\*\\*", "<b>$1</b>");
        out = out.replaceAll("`([^`]+)`", "<code>$1</code>");
        return out;
    }

    private int headingLevel(String line) {
        int level = 0;
        int max = Math.min(line.length(), 6);
        while (level < max && line.charAt(level) == '#') {
            level++;
        }
        if (level == 0 || level > 6) {
            return 0;
        }
        if (line.length() <= level) {
            return 0;
        }
        if (line.charAt(level) != ' ') {
            return 0;
        }
        return level;
    }

    private String parseBulletItem(String trimmed) {
        if (trimmed.startsWith("- ")) {
            return trimmed.substring(2).trim();
        }
        if (trimmed.startsWith("* ")) {
            return trimmed.substring(2).trim();
        }
        return null;
    }

    private String parseNumberedItem(String trimmed) {
        int idx = 0;
        while (idx < trimmed.length() && Character.isDigit(trimmed.charAt(idx))) {
            idx++;
        }
        if (idx == 0 || idx + 1 >= trimmed.length()) {
            return null;
        }
        char sep = trimmed.charAt(idx);
        if (sep != '.' && sep != ')') {
            return null;
        }
        if (trimmed.charAt(idx + 1) != ' ') {
            return null;
        }
        return trimmed.substring(idx + 2).trim();
    }

    private boolean isPotentialTableRow(String trimmed) {
        return trimmed.contains("|") && !trimmed.equals("|") && !trimmed.startsWith("```") && !trimmed.endsWith("```");
    }

    private boolean isTableSeparator(String trimmed) {
        if (!trimmed.contains("-")) {
            return false;
        }
        String t = trimmed;
        if (t.startsWith("|")) t = t.substring(1);
        if (t.endsWith("|")) t = t.substring(0, t.length() - 1);
        String[] parts = t.split("\\|", -1);
        if (parts.length < 2) {
            return false;
        }
        for (String p : parts) {
            String s = p.trim();
            if (s.isEmpty()) {
                continue;
            }
            s = s.replace(":", "");
            if (!s.matches("-+") || s.length() < 3) {
                return false;
            }
        }
        return true;
    }

    private String[] splitTableRow(String trimmed) {
        String t = trimmed;
        if (t.startsWith("|")) t = t.substring(1);
        if (t.endsWith("|")) t = t.substring(0, t.length() - 1);
        String[] parts = t.split("\\|", -1);
        for (int i = 0; i < parts.length; i++) {
            parts[i] = parts[i].trim();
        }
        return parts;
    }

    private String renderTable(java.util.List<String[]> rows, boolean hasHeader) {
        if (rows == null || rows.isEmpty()) {
            return "";
        }

        StringBuilder html = new StringBuilder();
        html.append("<table>");

        int startIndex = 0;
        if (hasHeader) {
            html.append("<thead><tr>");
            String[] header = rows.get(0);
            for (String cell : header) {
                html.append("<th>").append(applyInlineFormatting(cell)).append("</th>");
            }
            html.append("</tr></thead>");
            startIndex = 1;
        }

        html.append("<tbody>");
        for (int r = startIndex; r < rows.size(); r++) {
            html.append("<tr>");
            for (String cell : rows.get(r)) {
                html.append("<td>").append(applyInlineFormatting(cell)).append("</td>");
            }
            html.append("</tr>");
        }
        html.append("</tbody></table>");
        return html.toString();
    }
 private String escapeHtml(String input) {
        if (input == null) {
            return "";
        }
        return input
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String callPerplexityAPI(String prompt, String context) {
        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            JSONObject body = new JSONObject();
            body.put("model", model);

            JSONArray messages = new JSONArray();

            messages.put(new JSONObject()
                    .put("role", "system")
                    .put("content", "You are an AI learning assistant."));

            messages.put(new JSONObject()
                    .put("role", "user")
                    .put("content", prompt));

            body.put("messages", messages);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.toString().getBytes(StandardCharsets.UTF_8));
            }

            Scanner sc = new Scanner(conn.getInputStream(), StandardCharsets.UTF_8);
            StringBuilder response = new StringBuilder();
            while (sc.hasNext()) response.append(sc.nextLine());

            JSONObject json = new JSONObject(response.toString());
            return json.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getString("content");

        } catch (Exception e) {
            e.printStackTrace();
            return "AI service error. Please try again later.";
        }
    }

    public List<ChatHistory> getUserChatHistory(User user) {
        try {
            return firestoreService.getChatHistoryForUser(user);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load chat history from Firebase: " + e.getMessage(), e);
        }
    }

    public List<ChatHistory> getUserChatHistoryByTopic(User user, String topic) {
        try {
            return firestoreService.getChatHistoryForUserAndTopic(user, topic);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load chat history from Firebase: " + e.getMessage(), e);
        }
    }
}
