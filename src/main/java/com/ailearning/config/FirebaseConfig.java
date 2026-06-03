package com.ailearning.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.io.ByteArrayInputStream;
import java.io.IOException;


@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void init() {
        try {
            // InputStream serviceAccount = getClass()
            //         .getClassLoader()
            //         .getResourceAsStream("firebase-service-account.json");
            String serviceAccount = System.getenv("FIREBASE_SERVICE_ACCOUNT");

            if (serviceAccount == null) {
                throw new IllegalStateException(
                        "FIREBASE_SERVICE_ACCOUNT Env not found in Render Environment");
            }

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(new ByteArrayInputStream(serviceAccount.getBytes())))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }

        } catch (IOException e) {
            throw new IllegalStateException("Failed to initialize Firebase", e);
        }
    }

    @Bean
    @Primary
    public Firestore firestore() {
        return FirestoreClient.getFirestore();
    }
}
