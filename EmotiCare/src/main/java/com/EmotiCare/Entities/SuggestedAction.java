package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "suggested_actions")
public class SuggestedAction {
    @Id
    private String id;
    private String userId;
    private String category;
    private String description;
    private boolean done;

    public SuggestedAction() {}
    // getters/setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isDone() { return done; }
    public void setDone(boolean done) { this.done = done; }
}