package com.EmotiCare.AI;

import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class AISentimentService {

    private final Map<String, String[]> emotionKeywords = new HashMap<>();

    public AISentimentService() {
        emotionKeywords.put("happy", new String[]{"happy", "joy", "excited", "glad", "cheerful"});
        emotionKeywords.put("sad", new String[]{"sad", "down", "unhappy", "gloomy", "depressed"});
        emotionKeywords.put("stressed", new String[]{"stress", "anxious", "overwhelmed", "tense"});
        emotionKeywords.put("angry", new String[]{"angry", "mad", "frustrated", "irritated"});
        emotionKeywords.put("fearful", new String[]{"scared", "afraid", "fear", "nervous"});
        emotionKeywords.put("lonely", new String[]{"lonely", "isolated", "alone"});
        emotionKeywords.put("bored", new String[]{"bored", "unmotivated", "disinterested"});
        emotionKeywords.put("surprised", new String[]{"surprised", "shocked", "astonished"});
        emotionKeywords.put("confident", new String[]{"confident", "proud", "capable"});
        emotionKeywords.put("neutral", new String[]{});
    }

    public String analyzeSentiment(String message) {
        String lowerMessage = message.toLowerCase();

        for (Map.Entry<String, String[]> entry : emotionKeywords.entrySet()) {
            for (String keyword : entry.getValue()) {
                if (lowerMessage.contains(keyword)) {
                    return entry.getKey();
                }
            }
        }

        return "neutral";
    }
}
