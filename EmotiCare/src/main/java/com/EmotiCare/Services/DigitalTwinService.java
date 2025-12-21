package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.UserAIMemory;
import com.EmotiCare.Repositories.ConversationRepository;
import com.EmotiCare.Repositories.UserAIMemoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DigitalTwinService {

        private final UserAIMemoryRepository repo;
        private final ConversationRepository convoRepo;
        private final GroqService groq;

        public void update(String userId) {

                List<ConversationMessage> msgs = convoRepo.findByUserIdAndTimestampAfter(
                                userId, LocalDateTime.now().minusDays(14));

                if (msgs.size() < 10)
                        return;

                Map<String, Long> emotionCount = msgs.stream()
                                .collect(Collectors.groupingBy(
                                                ConversationMessage::getSentiment,
                                                Collectors.counting()));

                String dominant = Collections.max(emotionCount.entrySet(),
                                Map.Entry.comparingByValue()).getKey();

                String system = "From these messages, infer ONE stress trigger "
                                + "and ONE coping preference. Format as 'Trigger: [trigger] | Coping: [coping]'. Short.";

                String aiResult = groq.ask(system, userId,
                                msgs.stream()
                                                .map(ConversationMessage::getContent)
                                                .collect(Collectors.joining("\n")));

                UserAIMemory mem = repo.findById(userId)
                                .orElse(new UserAIMemory());

                mem.setUserId(userId);
                mem.setDominantEmotion(dominant);
                mem.setStressTrigger(extractTrigger(aiResult));
                mem.setPreferredCoping(extractCoping(aiResult));
                mem.setUpdatedAt(LocalDateTime.now());

                repo.save(mem);
        }

        private String extractTrigger(String text) {
                if (text == null)
                        return "Unknown";
                try {
                        if (text.contains("Trigger:") && text.contains("|")) {
                                return text.substring(text.indexOf("Trigger:") + 8, text.indexOf("|")).trim();
                        }
                } catch (Exception e) {
                        // ignore
                }
                return "Unknown";
        }

        private String extractCoping(String text) {
                if (text == null)
                        return "Unknown";
                try {
                        if (text.contains("Coping:")) {
                                return text.substring(text.indexOf("Coping:") + 7).trim();
                        }
                } catch (Exception e) {
                        // ignore
                }
                return "Unknown";
        }
}
