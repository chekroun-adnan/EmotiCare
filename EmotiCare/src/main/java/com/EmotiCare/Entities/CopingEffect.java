package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "coping_effects")
public class CopingEffect {
    @Id
    private Long id;

    private String userId;
    private String coping;
    private int success;
    private int attempts;

    public CopingEffect() {
    }

    public CopingEffect(Long id, String userId, String coping, int success, int attempts) {
        this.id = id;
        this.userId = userId;
        this.coping = coping;
        this.success = success;
        this.attempts = attempts;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCoping() {
        return coping;
    }

    public void setCoping(String coping) {
        this.coping = coping;
    }

    public int getSuccess() {
        return success;
    }

    public void setSuccess(int success) {
        this.success = success;
    }

    public int getAttempts() {
        return attempts;
    }

    public void setAttempts(int attempts) {
        this.attempts = attempts;
    }
}
