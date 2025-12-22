package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.AudioMessage;
import com.EmotiCare.Services.AudioMessageService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AudioMessageControllerTest {

    @Mock
    private AudioMessageService audioService;

    @InjectMocks
    private AudioMessageController controller;

    @Test
    void saveAudioMessage_returnsOk() {
        AudioMessage msg = new AudioMessage();
        when(audioService.saveAudioMessage("u1", "url")).thenReturn(msg);

        ResponseEntity<AudioMessage> response = controller.saveAudioMessage("u1", "url");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getAudioMessage_returnsOk() {
        when(audioService.getAudioMessage("1")).thenReturn(Optional.of(new AudioMessage()));
        ResponseEntity<?> response = controller.getAudioMessage("1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getUserAudioMessages_returnsList() {
        when(audioService.getAudioMessagesForUser("u1")).thenReturn(List.of(new AudioMessage()));
        ResponseEntity<List<AudioMessage>> response = controller.getUserAudioMessages("u1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void deleteAudioMessage_deletes() {
        ResponseEntity<String> response = controller.deleteAudioMessage("1");
        verify(audioService).deleteAudioMessage("1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void analyzeAudio_returnsAnalysis() {
        when(audioService.analyzeAudioTranscriptWithAI("u1", "trans")).thenReturn("Analysis");
        ResponseEntity<String> response = controller.analyzeAudio("u1", "trans");
        assertThat(response.getBody()).isEqualTo("Analysis");
    }
}
