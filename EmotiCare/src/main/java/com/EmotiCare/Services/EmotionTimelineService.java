package com.EmotiCare.Services;

import com.EmotiCare.Entities.Emotion;
import com.EmotiCare.Repositories.ConversationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EmotionTimelineService {

    private final ConversationRepository repo;


    public int emotionScore(Emotion e) {
        return switch (e) {
            case JOY, CONFIDENT -> 2;
            case NEUTRAL -> 1;
            default -> 0;
        };
    }

    public List<EmotionPoint> timeline(String userId, int days) {
        LocalDateTime from = LocalDateTime.now().minusDays(days);

        return repo.findByUserIdAndTimestampAfter(userId, from)
                .stream()
                .map(m -> new EmotionPoint(
                        m.getTimestamp(),
                        Emotion.valueOf(m.getSentiment().toUpperCase()),
                        emotionScore(Emotion.valueOf(m.getSentiment().toUpperCase()))
                ))
                .toList();
    }

    public record EmotionPoint(
            LocalDateTime time,
            Emotion emotion,
            int score
    ) {}
}

