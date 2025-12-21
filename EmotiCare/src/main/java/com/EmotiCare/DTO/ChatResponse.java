package com.EmotiCare.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Map;

@Data
@AllArgsConstructor
public class ChatResponse {

    private boolean crisis;
    private String reply;
    private String sentiment;
    private String recommendations;
    private Map<String, Object> actions;
    private java.util.List<Object> goals;
    private java.util.List<Object> habits;

    public static ChatResponse crisis(String msg) {
        return new ChatResponse(true, msg, null, null, null, null, null);
    }

    public static ChatResponse normal(
            String reply,
            String sentiment,
            String recommendations,
            Map<String, Object> actions,
            java.util.List<Object> goals,
            java.util.List<Object> habits) {
        return new ChatResponse(false, reply, sentiment, recommendations, actions, goals, habits);
    }
}
