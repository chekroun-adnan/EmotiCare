package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.AIResponseFeedback;
import com.EmotiCare.Repositories.AIResponseFeedbackRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AIResponseFeedbackService {

    private final AIResponseFeedbackRepository feedbackRepository;
    private final GroqService groqService;

    public AIResponseFeedbackService(AIResponseFeedbackRepository feedbackRepository,
                                     GroqService groqService) {
        this.feedbackRepository = feedbackRepository;
        this.groqService = groqService;
    }

    public AIResponseFeedback saveFeedback(AIResponseFeedback feedback) {
        return feedbackRepository.save(feedback);
    }

    public Optional<AIResponseFeedback> getFeedbackById(String id) {
        return feedbackRepository.findById(id);
    }

    public List<AIResponseFeedback> getFeedbackForUser(String userId) {
        return feedbackRepository.findByUserId(userId);
    }

    public void deleteFeedback(String id) {
        feedbackRepository.deleteById(id);
    }

    public String analyzeFeedbackWithAI(String userId) {
        List<AIResponseFeedback> feedbacks = getFeedbackForUser(userId);
        if (feedbacks.isEmpty()) return "No feedback available for analysis.";

        StringBuilder sb = new StringBuilder();
        for (AIResponseFeedback f : feedbacks) {
            sb.append("Rating: ").append(f.getRating()).append(" Comment: ").append(
                    f.getComment() == null ? "" : f.getComment()).append("\n");
        }

        String system = "You are an assistant that analyzes user feedback about AI responses. " +
                "Summarize main strengths and common complaints in 3 bullet points.";
        return groqService.ask(system, userId, sb.toString());
    }
}
