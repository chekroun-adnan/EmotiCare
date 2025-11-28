package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "all_interactions")
public class AllInteractionHistory {
    @Id
    private String id;
    private String userId;
    private List<String> moodIds;
    private List<String> journalIds;
    private List<String> messageIds;
    private List<String> habitEntryIds;
    private List<String> goalIds;

    public AllInteractionHistory() {}

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

    public List<String> getMoodIds() {
        return moodIds;
    }

    public void setMoodIds(List<String> moodIds) {
        this.moodIds = moodIds;
    }

    public List<String> getJournalIds() {
        return journalIds;
    }

    public void setJournalIds(List<String> journalIds) {
        this.journalIds = journalIds;
    }

    public List<String> getMessageIds() {
        return messageIds;
    }

    public void setMessageIds(List<String> messageIds) {
        this.messageIds = messageIds;
    }

    public List<String> getHabitEntryIds() {
        return habitEntryIds;
    }

    public void setHabitEntryIds(List<String> habitEntryIds) {
        this.habitEntryIds = habitEntryIds;
    }

    public List<String> getGoalIds() {
        return goalIds;
    }

    public void setGoalIds(List<String> goalIds) {
        this.goalIds = goalIds;
    }
}
