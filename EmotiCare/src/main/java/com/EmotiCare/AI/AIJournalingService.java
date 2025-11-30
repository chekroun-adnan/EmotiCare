package com.EmotiCare.AI;

import org.springframework.stereotype.Service;
import java.util.Random;

@Service
public class AIJournalingService {
    private final String[] prompts = {
            "How do you feel today?",
            "Describe a challenge you faced this week.",
            "What made you happy recently?",
            "Write about a stressful moment and how you handled it."
    };
    public String generatePrompt(){ return prompts[new Random().nextInt(prompts.length)]; }
}
