package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProactiveAIService {

    private final UserRepository userRepository;
    private final GroqService groqService;

    public ProactiveAIService(UserRepository userRepository, GroqService groqService) {
        this.userRepository = userRepository;
        this.groqService = groqService;
    }

    @Scheduled(cron = "0 0 10 * * ?")
    public void dailyCheckInAllUsers() {
        List<User> users = userRepository.findAll();
        for (User u : users) {
            if (u == null || u.getId() == null) continue;
            String prompt = "You are a friendly assistant. Send a short 1-2 sentence check-in asking how the user is feeling today and offering a quick coping tip.";
            String reply = groqService.ask(prompt, u.getId(), "Daily check-in");
        }
    }

    public String manualCheckIn(String userId) {
        String prompt = "You are a friendly assistant. Send a short 1-2 sentence check-in asking how the user is feeling today and offering a quick coping tip.";
        return groqService.ask(prompt, userId, "Manual check-in");
    }
}
