package com.EmotiCare.Services;

import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Repositories.ConversationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EmotionalPatternService {

    private final ConversationRepository repo;

    public String detectPattern(String userId) {
        List<ConversationMessage> msgs =
                repo.findByUserIdAndTimestampAfter(
                        userId, LocalDateTime.now().minusDays(21));

        long nightStress =
                msgs.stream()
                        .filter(m -> m.getTimestamp().getHour() >= 22)
                        .filter(m -> m.getSentiment().equals("stressed"))
                        .count();

        if (nightStress >= 3)
            return "Stress seems to appear more often late at night.";

        return "No strong emotional pattern detected yet.";
    }
}

