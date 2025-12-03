package com.EmotiCare.Services;

import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class AICrisisDetectionService {

    private final List<String> crisisKeywords = Arrays.asList(
            "suicide","kill myself","want to die","end my life","i'm going to kill myself",
            "hurt myself","cant go on","please help me","i need help now"
    );

    public boolean isCrisis(String message) {
        if (message == null) return false;
        String lower = message.toLowerCase();
        return crisisKeywords.stream().anyMatch(lower::contains);
    }

    public String getEmergencyMessage() {
        return "I'm really sorry you're feeling this way. If you're in immediate danger, call emergency services now. " +
                "If you're in the US you can call 988 for crisis support. Please seek immediate help.";
    }
}
