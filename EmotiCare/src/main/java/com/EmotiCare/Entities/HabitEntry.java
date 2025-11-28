package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Document(collection = "habit_entries")
public class HabitEntry {
    @Id
    private String id;
    private String habitId;
    private String userId;
    private boolean completed;
    private LocalDateTime timestamp = LocalDateTime.now();

    public HabitEntry() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getHabitId() { return habitId; }
    public void setHabitId(String habitId) { this.habitId = habitId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}