package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "conversation_messages")
public class ConversationMessage {

    @Id
    private String id;

    private String userId;
    private String sender;
    private String content;
    private String sentiment;
    private LocalDateTime timestamp = LocalDateTime.now();

    public ConversationMessage() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public String getSentiment() {
        return sentiment;
    }

    public void setSentiment(String sentiment) {
        this.sentiment = sentiment;
    }

    private java.util.Map<String, Object> suggestions;

    public java.util.Map<String, Object> getSuggestions() {
        return suggestions;
    }

    public void setSuggestions(java.util.Map<String, Object> suggestions) {
        this.suggestions = suggestions;
    }
}