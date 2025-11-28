package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.List;

@Document(collection = "weekly_summaries")
public class WeeklySummary {
    @Id
    private String id;
    private String userId;
    private String summaryText;
    private List<String> moodIds;
    private List<String> journalIds;
    private List<String> habitIds;
    private String aiGeneratedAdvice;

    public WeeklySummary() {}
    // getters/setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getSummaryText() { return summaryText; }
    public void setSummaryText(String summaryText) { this.summaryText = summaryText; }
    public List<String> getMoodIds() { return moodIds; }
    public void setMoodIds(List<String> moodIds) { this.moodIds = moodIds; }
    public List<String> getJournalIds() { return journalIds; }
    public void setJournalIds(List<String> journalIds) { this.journalIds = journalIds; }
    public List<String> getHabitIds() { return habitIds; }
    public void setHabitIds(List<String> habitIds) { this.habitIds = habitIds; }
    public String getAiGeneratedAdvice() { return aiGeneratedAdvice; }
    public void setAiGeneratedAdvice(String aiGeneratedAdvice) { this.aiGeneratedAdvice = aiGeneratedAdvice; }
}

