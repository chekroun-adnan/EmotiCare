package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.AudioMessage;
import com.EmotiCare.Repositories.AudioMessageRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AudioMessageService {

    private final AudioMessageRepository audioRepository;
    private final GroqService groqService;

    public AudioMessageService(AudioMessageRepository audioRepository, GroqService groqService) {
        this.audioRepository = audioRepository;
        this.groqService = groqService;
    }

    public AudioMessage saveAudioMessage(String userId, String url) {
        AudioMessage a = new AudioMessage();
        a.setUserId(userId);
        a.setUrl(url);
        a.setTimestamp(LocalDateTime.now());
        return audioRepository.save(a);
    }

    public Optional<AudioMessage> getAudioMessage(String id) {
        return audioRepository.findById(id);
    }

    public List<AudioMessage> getAudioMessagesForUser(String userId) {
        return audioRepository.findByUserId(userId);
    }

    public void deleteAudioMessage(String id) {
        audioRepository.deleteById(id);
    }

    public String analyzeAudioTranscriptWithAI(String userId, String transcript) {
        if (transcript == null || transcript.trim().isEmpty()) return "No transcript provided.";
        String system = "Summarize the following audio transcript into 2 brief bullet points and one suggested action.";
        return groqService.ask(system, userId, transcript);
    }
}