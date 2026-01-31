package com.ailearning.service;

import com.ailearning.model.ChatHistory;
import com.ailearning.model.User;
import com.ailearning.model.UserRole;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ExecutionException;

@Service
public class FirestoreService {

    private static final String USERS_COLLECTION = "users";
    private static final String CHAT_COLLECTION = "chat_history";

    private final Firestore firestore;

    public FirestoreService(Firestore firestore) {
        this.firestore = firestore;
    }

    
    public void saveUser(User user)
            throws ExecutionException, InterruptedException {

        if (user.getCreatedAt() == null) {
            user.setCreatedAt(LocalDateTime.now());
        }

        Map<String, Object> data = new HashMap<>();
        data.put("username", user.getUsername());
        data.put("password", user.getPassword());
        data.put("email", user.getEmail());
        data.put("firstName", user.getFirstName());
        data.put("lastName", user.getLastName());
        data.put("role", user.getRole() != null ? user.getRole().name() : null);
        data.put("createdAt", user.getCreatedAt().toString());
        data.put("lastLogin",
                user.getLastLogin() != null ? user.getLastLogin().toString() : null);

        firestore.collection(USERS_COLLECTION)
                .document(user.getUsername())
                .set(data)
                .get();
    }

    public Optional<User> findUserByUsername(String username)
            throws ExecutionException, InterruptedException {

        DocumentSnapshot doc = firestore
                .collection(USERS_COLLECTION)
                .document(username)
                .get()
                .get();

        if (!doc.exists()) {
            return Optional.empty();
        }
        return Optional.of(mapDocumentToUser(doc));
    }

    public boolean existsByUsername(String username)
            throws ExecutionException, InterruptedException {
        return findUserByUsername(username).isPresent();
    }

    public boolean existsByEmail(String email)
            throws ExecutionException, InterruptedException {

        QuerySnapshot snapshot = firestore
                .collection(USERS_COLLECTION)
                .whereEqualTo("email", email)
                .limit(1)
                .get()
                .get();

        return !snapshot.isEmpty();
    }

    public void updateUserLastLogin(String username, LocalDateTime lastLogin)
            throws ExecutionException, InterruptedException {

        firestore.collection(USERS_COLLECTION)
                .document(username)
                .update("lastLogin", lastLogin.toString())
                .get();
    }

    private User mapDocumentToUser(DocumentSnapshot doc) {
        User user = new User();

        user.setUsername(doc.getString("username"));
        user.setPassword(doc.getString("password"));
        user.setEmail(doc.getString("email"));
        user.setFirstName(doc.getString("firstName"));
        user.setLastName(doc.getString("lastName"));

        String roleStr = doc.getString("role");
        if (roleStr != null) {
            try {
                user.setRole(UserRole.valueOf(roleStr));
            } catch (IllegalArgumentException ignored) {}
        }

        if (doc.getString("createdAt") != null) {
            user.setCreatedAt(LocalDateTime.parse(doc.getString("createdAt")));
        }

        if (doc.getString("lastLogin") != null) {
            user.setLastLogin(LocalDateTime.parse(doc.getString("lastLogin")));
        }

        return user;
    }

    
    public ChatHistory saveChatHistory(User user, ChatHistory chatHistory)
            throws ExecutionException, InterruptedException {

        LocalDateTime timestamp =
                chatHistory.getTimestamp() != null
                        ? chatHistory.getTimestamp()
                        : LocalDateTime.now();

        chatHistory.setTimestamp(timestamp);

        Map<String, Object> data = new HashMap<>();
        data.put("username", user.getUsername());
        data.put("userMessage", chatHistory.getUserMessage());
        data.put("botResponse", chatHistory.getBotResponse());
        data.put("topic", chatHistory.getTopic());
        data.put("timestamp", timestamp.toString());

        firestore.collection(CHAT_COLLECTION)
                .add(data)
                .get();

        return chatHistory;
    }

    public List<ChatHistory> getChatHistoryForUser(User user)
            throws ExecutionException, InterruptedException {

        QuerySnapshot snapshot = firestore
                .collection(CHAT_COLLECTION)
                .whereEqualTo("username", user.getUsername())
                .orderBy("timestamp", Query.Direction.DESCENDING)
                .get()
                .get();

        List<ChatHistory> result = new ArrayList<>();
        for (QueryDocumentSnapshot doc : snapshot) {
            result.add(mapDocumentToChatHistory(user, doc));
        }
        return result;
    }

    public List<ChatHistory> getChatHistoryForUserAndTopic(User user, String topic)
            throws ExecutionException, InterruptedException {

        QuerySnapshot snapshot = firestore
                .collection(CHAT_COLLECTION)
                .whereEqualTo("username", user.getUsername())
                .whereEqualTo("topic", topic)
                .orderBy("timestamp", Query.Direction.DESCENDING)
                .get()
                .get();

        List<ChatHistory> result = new ArrayList<>();
        for (QueryDocumentSnapshot doc : snapshot) {
            result.add(mapDocumentToChatHistory(user, doc));
        }
        return result;
    }

    private ChatHistory mapDocumentToChatHistory(User user, DocumentSnapshot doc) {
        ChatHistory history = new ChatHistory();

        history.setUser(user);
        history.setUserMessage(doc.getString("userMessage"));
        history.setBotResponse(doc.getString("botResponse"));
        history.setTopic(doc.getString("topic"));

        if (doc.getString("timestamp") != null) {
            history.setTimestamp(LocalDateTime.parse(doc.getString("timestamp")));
        }

        return history;
    }
}
