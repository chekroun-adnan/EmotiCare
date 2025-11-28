package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "therapy_sessions")
public class TherapySession {
    @Id
    private String id;
    private String userId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private List<String> messageIds;

    public TherapySession() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    public List<String> getMessageIds() { return messageIds; }
    public void setMessageIds(List<String> messageIds) { this.messageIds = messageIds; }
}
