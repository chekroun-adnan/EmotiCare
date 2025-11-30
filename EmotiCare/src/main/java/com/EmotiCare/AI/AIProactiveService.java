package com.EmotiCare.AI;

import com.EmotiCare.Repositories.UserRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class AIProactiveService {
    private final UserRepository userRepository;
    private final GroqService groqService;

    public AIProactiveService(UserRepository userRepository, GroqService groqService) {
        this.userRepository = userRepository;
        this.groqService = groqService;
    }

    @Scheduled(cron = "0 0 10 * * ?")
    public void dailyCheckIn() {
        userRepository.findAll().forEach(user -> {
            String msg = "Hi " + user.getFirstName() + ", how are you feeling today?";
            groqService.generateTherapyMessageAndSave(user.getId(), msg);
        });
    }
}
