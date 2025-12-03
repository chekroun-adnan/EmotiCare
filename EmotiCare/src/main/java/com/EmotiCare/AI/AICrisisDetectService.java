package com.EmotiCare.AI;

import org.springframework.stereotype.Service;

@Service
public class AICrisisDetectService {
    public boolean isCrisis(String message){
        String lower = message.toLowerCase();
        return lower.contains("suicide") || lower.contains("hopeless") || lower.contains("want to die");
    }
    public String getEmergencyMessage(){
        return "It seems you are in distress. Please contact professional help immediately: +1-800-273-8255 (US)";
    }
}
