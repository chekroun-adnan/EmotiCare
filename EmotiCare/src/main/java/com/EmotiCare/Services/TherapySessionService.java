package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.TherapySession;
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

    public TherapySessionService(TherapySessionRepository therapySessionRepository,
                                 ConversationRepository conversationMessageRepository,
                                 GroqService groqService) {
        this.therapySessionRepository = therapySessionRepository;
        this.conversationMessageRepository = conversationMessageRepository;
        this.groqService = groqService;
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
        return therapySessionRepository.findById(sessionId);
    }

    public List<TherapySession> getSessionsForUser(String userId) {
        return therapySessionRepository.findByUserId(userId);
    }

    public String summarizeSessionWithAI(String sessionId) {
        TherapySession s = therapySessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found"));

        List<String> messageIds = s.getMessageIds();
        if (messageIds == null || messageIds.isEmpty()) {
            // fallback: collect all messages for user
            List<ConversationMessage> msgs = conversationMessageRepository.findByUserId(s.getUserId());
            messageIds = msgs.stream().map(ConversationMessage::getId).collect(Collectors.toList());
        }

        // gather message content
        List<ConversationMessage> msgs = new ArrayList<>();
        for (String mid : messageIds) {
            conversationMessageRepository.findById(mid).ifPresent(msgs::add);
        }
        if (msgs.isEmpty()) return "No messages available for summary.";

        String concatenated = msgs.stream()
                .sorted(Comparator.comparing(ConversationMessage::getTimestamp))
                .map(m -> m.getSender() + ": " + m.getContent())
                .collect(Collectors.joining("\n"));

        String system = "Summarize the therapy session into 5 concise insights and 3 recommended next steps tailored to the user.";
        return groqService.ask(system, s.getUserId(), concatenated);
    }
}
