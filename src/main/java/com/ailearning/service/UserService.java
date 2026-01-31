package com.ailearning.service;

import com.ailearning.model.User;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.concurrent.ExecutionException;

@Service
public class UserService {

    private final FirestoreService firestoreService;

    public UserService(FirestoreService firestoreService) {
        this.firestoreService = firestoreService;
    }

    public User registerUser(User user) {
        try {
            if (firestoreService.existsByUsername(user.getUsername())) {
                throw new RuntimeException("Username already exists");
            }
            if (firestoreService.existsByEmail(user.getEmail())) {
                throw new RuntimeException("Email already exists");
            }
            user.setCreatedAt(LocalDateTime.now());
            firestoreService.saveUser(user);
            return user;
        } catch (ExecutionException | InterruptedException e) {
            throw new RuntimeException("Failed to register user in Firebase: " + e.getMessage(), e);
        }
    }

    public Optional<User> login(String username, String password) {
        try {
            Optional<User> userOpt = firestoreService.findUserByUsername(username);
            if (userOpt.isPresent() && userOpt.get().getPassword().equals(password)) {
                User loggedInUser = userOpt.get();
                LocalDateTime now = LocalDateTime.now();
                loggedInUser.setLastLogin(now);
                firestoreService.updateUserLastLogin(username, now);
                return Optional.of(loggedInUser);
            }
            return Optional.empty();
        } catch (ExecutionException | InterruptedException e) {
            throw new RuntimeException("Login failed due to Firebase error: " + e.getMessage(), e);
        }
    }

    public Optional<User> findByUsername(String username) {
        try {
            return firestoreService.findUserByUsername(username);
        } catch (ExecutionException | InterruptedException e) {
            throw new RuntimeException("Failed to load user from Firebase: " + e.getMessage(), e);
        }
    }
}