package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.AudioMessage;
import com.EmotiCare.Repositories.AudioMessageRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AudioMessageServiceTest {

    @Mock
    private AudioMessageRepository audioRepository;
    @Mock
    private GroqService groqService;

    @InjectMocks
    private AudioMessageService service;

    @Test
    void saveAudioMessage_saves() {
        when(audioRepository.save(any())).thenReturn(new AudioMessage());
        service.saveAudioMessage("u1", "url");
        verify(audioRepository).save(any());
    }

    @Test
    void getAudioMessage_returnsOptional() {
        when(audioRepository.findById("a1")).thenReturn(Optional.of(new AudioMessage()));
        assertThat(service.getAudioMessage("a1")).isPresent();
    }

    @Test
    void getAudioMessagesForUser_returnsList() {
        when(audioRepository.findByUserId("u1")).thenReturn(List.of(new AudioMessage()));
        assertThat(service.getAudioMessagesForUser("u1")).hasSize(1);
    }

    @Test
    void analyzeAudioTranscriptWithAI_returnsSummary() {
        when(groqService.ask(any(), eq("u1"), any())).thenReturn("Summary");
        String result = service.analyzeAudioTranscriptWithAI("u1", "Transcript");
        assertThat(result).isEqualTo("Summary");
    }
}
