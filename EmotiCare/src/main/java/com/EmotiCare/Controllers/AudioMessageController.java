package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.AudioMessage;
import com.EmotiCare.Services.AudioMessageService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/audio")
public class AudioMessageController {

    private final AudioMessageService audioService;

    public AudioMessageController(AudioMessageService audioService) {
        this.audioService = audioService;
    }

    @PostMapping("/save")
    public ResponseEntity<AudioMessage> saveAudioMessage(
            @RequestParam String userId,
            @RequestParam String url) {

        return ResponseEntity.ok(audioService.saveAudioMessage(userId, url));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAudioMessage(@PathVariable String id) {
        Optional<AudioMessage> msg = audioService.getAudioMessage(id);
        return msg.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<AudioMessage>> getUserAudioMessages(@PathVariable String userId) {
        return ResponseEntity.ok(audioService.getAudioMessagesForUser(userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteAudioMessage(@PathVariable String id) {
        audioService.deleteAudioMessage(id);
        return ResponseEntity.ok("Audio message deleted");
    }

    @PostMapping("/analyze")
    public ResponseEntity<String> analyzeAudio(
            @RequestParam String userId,
            @RequestParam String transcript) {

        return ResponseEntity.ok(audioService.analyzeAudioTranscriptWithAI(userId, transcript));
    }
}
