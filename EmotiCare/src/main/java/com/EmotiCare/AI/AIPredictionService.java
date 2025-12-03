package com.EmotiCare.AI;

import org.springframework.stereotype.Service;

@Service
public class AIPredictionService {

    private final GroqService groqService;

    public AIPredictionService(GroqService groqService) {
        this.groqService = groqService;
    }

    public String predictNextMood(String userMessage) {
        return groqService.predictMood("system", userMessage);
    }
}
