package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "Twin")
public class UserAIMemory {
    @Id
    private String userId;

    private String dominantEmotion;
    private String preferredCoping;
    private String stressTrigger;
    private LocalDateTime updatedAt;

    public UserAIMemory() {
    }

    public UserAIMemory(String userId, String dominantEmotion, String preferredCoping, String stressTrigger, LocalDateTime updatedAt) {
        this.userId = userId;
        this.dominantEmotion = dominantEmotion;
        this.preferredCoping = preferredCoping;
        this.stressTrigger = stressTrigger;
        this.updatedAt = updatedAt;
    }


    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDominantEmotion() {
        return dominantEmotion;
    }

    public void setDominantEmotion(String dominantEmotion) {
        this.dominantEmotion = dominantEmotion;
    }

    public String getPreferredCoping() {
        return preferredCoping;
    }

    public void setPreferredCoping(String preferredCoping) {
        this.preferredCoping = preferredCoping;
    }

    public String getStressTrigger() {
        return stressTrigger;
    }

    public void setStressTrigger(String stressTrigger) {
        this.stressTrigger = stressTrigger;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
