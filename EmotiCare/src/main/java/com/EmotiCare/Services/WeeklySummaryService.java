package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.*;
import com.EmotiCare.Repositories.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WeeklySummaryService {

        private final WeeklySummaryRepository weeklyRepo;
        private final ConversationRepository convRepo;
        private final HabitRepository habitRepo;
        private final GroqService groq;

        public WeeklySummary createWeeklySummary(String userId) {
                LocalDateTime weekAgo = LocalDateTime.now().minusDays(7);
                List<ConversationMessage> msgs = convRepo.findByUserIdAndTimestampAfter(userId, weekAgo);

                // Basic gathering of data
                WeeklySummary summary = new WeeklySummary();
                summary.setUserId(userId);

                String chatContent = msgs.stream().map(ConversationMessage::getContent)
                                .collect(Collectors.joining("\n"));
                if (chatContent.isEmpty())
                        chatContent = "No chat activity.";

                String system = "Generate a weekly summary for the user based on their chat history. Be supportive and highlight progress.";
                String advice = groq.ask(system, userId, chatContent);

                summary.setSummaryText("Weekly summary generated.");
                summary.setAiGeneratedAdvice(advice);

                return weeklyRepo.save(summary);
        }

        public List<WeeklySummary> getSummariesForUser(String userId) {
                return weeklyRepo.findByUserId(userId);
        }

        public Optional<WeeklySummary> getSummaryById(String id) {
                return weeklyRepo.findById(id);
        }

        public void deleteSummary(String id) {
                weeklyRepo.deleteById(id);
        }
}
