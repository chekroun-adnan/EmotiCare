package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "journal_entries")
public class JournalEntry {
    @Id
    private String entryId;
    @DBRef
    private User user;
    private String content;
    private Double sentimentScore;
    private List<String> emotionTags;
    private LocalDateTime createdAt;

    public String getEntryId() {
        return entryId;
    }

    public void setEntryId(String entryId) {
        this.entryId = entryId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Double getSentimentScore() {
        return sentimentScore;
    }

    public void setSentimentScore(Double sentimentScore) {
        this.sentimentScore = sentimentScore;
    }

    public List<String> getEmotionTags() {
        return emotionTags;
    }

    public void setEmotionTags(List<String> emotionTags) {
        this.emotionTags = emotionTags;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
