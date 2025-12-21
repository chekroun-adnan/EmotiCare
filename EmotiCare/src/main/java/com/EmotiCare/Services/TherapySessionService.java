package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.TherapySession;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.ConversationRepository;
import com.EmotiCare.Repositories.TherapySessionRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class TherapySessionService {

    private final TherapySessionRepository therapySessionRepository;
    private final ConversationRepository conversationMessageRepository;
    private final GroqService groqService;
    private final AuthService authService;

    public TherapySessionService(TherapySessionRepository therapySessionRepository,
                                 ConversationRepository conversationMessageRepository,
                                 GroqService groqService, AuthService authService) {
        this.therapySessionRepository = therapySessionRepository;
        this.conversationMessageRepository = conversationMessageRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public TherapySession startSession(String userId) {
        TherapySession s = new TherapySession();
        s.setUserId(userId);
        s.setStartTime(LocalDateTime.now());
        s.setMessageIds(new ArrayList<>());
        return therapySessionRepository.save(s);
    }

    public TherapySession endSession(String sessionId) {
        TherapySession s = therapySessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));
        s.setEndTime(LocalDateTime.now());

        if (s.getMessageIds() == null || s.getMessageIds().isEmpty()) {
            List<ConversationMessage> msgs = conversationMessageRepository.findByUserId(s.getUserId());
            List<String> ids = msgs.stream().map(ConversationMessage::getId).collect(Collectors.toList());
            s.setMessageIds(ids);
        }

        return therapySessionRepository.save(s);
    }

    public Optional<TherapySession> getSession(String sessionId) {
        User currentUser = authService.getCurrentUser();

        TherapySession session = therapySessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        if (!session.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        return Optional.of(session);
    }

    public List<TherapySession> getSessionsForUser(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }
        return therapySessionRepository.findByUserId(userId);
    }

    public String summarizeSessionWithAI(String sessionId) {
        User currentUser = authService.getCurrentUser();

        TherapySession s = therapySessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        // SECURITY: Check ownership
        if (!s.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        List<String> messageIds = s.getMessageIds();
        if (messageIds == null || messageIds.isEmpty()) {
            return "No messages available for summary.";
        }

        List<ConversationMessage> msgs = conversationMessageRepository.findAllById(messageIds);

        if (msgs.isEmpty()) {
            return "No messages available for summary.";
        }

        String concatenated = msgs.stream()
                .sorted(Comparator.comparing(ConversationMessage::getTimestamp))
                .map(m -> m.getSender() + ": " + m.getContent())
                .collect(Collectors.joining("\n"));

        String system =
                "Summarize the therapy session into exactly 5 concise psychological insights "
                        + "and 3 actionable recommendations for the user's wellbeing.";

        return groqService.ask(system, currentUser.getId(), concatenated);
    }
}
