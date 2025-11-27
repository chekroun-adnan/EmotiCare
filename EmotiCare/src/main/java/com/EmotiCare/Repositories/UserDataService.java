package com.EmotiCare.Repositories;

import java.util.Map;

public interface UserDataService {
    /**
     * Return a Map containing: moodHistory, journalEntries, habits, goals, pastMessages, etc.
     * Example keys: "moodHistory", "journalEntries", "habits", "goals", "pastMessages"
     */
    Map<String, Object> getUserData(String userId);
}
