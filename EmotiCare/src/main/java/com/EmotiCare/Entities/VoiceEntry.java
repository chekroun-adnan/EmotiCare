package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "voice_entries")
public class VoiceEntry {
    @Id
    private String voiceId;
    @DBRef
    private User user;
    private String storageRef;
    private String transcript;
    private List<String> emotionTags;
    private Double sentimentScore;
    private LocalDateTime createdAt;

    public String getVoiceId() {
        return voiceId;
    }

    public void setVoiceId(String voiceId) {
        this.voiceId = voiceId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getStorageRef() {
        return storageRef;
    }

    public void setStorageRef(String storageRef) {
        this.storageRef = storageRef;
    }

    public String getTranscript() {
        return transcript;
    }

    public void setTranscript(String transcript) {
        this.transcript = transcript;
    }

    public List<String> getEmotionTags() {
        return emotionTags;
    }

    public void setEmotionTags(List<String> emotionTags) {
        this.emotionTags = emotionTags;
    }

    public Double getSentimentScore() {
        return sentimentScore;
    }

    public void setSentimentScore(Double sentimentScore) {
        this.sentimentScore = sentimentScore;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
