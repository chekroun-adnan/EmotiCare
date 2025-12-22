package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.UserAIMemory;
import com.EmotiCare.Repositories.UserAIMemoryRepository;
import com.EmotiCare.Services.DigitalTwinService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TwinControllerTest {

    @Mock
    private UserAIMemoryRepository twinRepository;
    @Mock
    private DigitalTwinService twinService;

    @InjectMocks
    private TwinController controller;

    @Test
    void getTwin_returnsTwin_whenExists() {
        UserAIMemory twin = new UserAIMemory();
        when(twinRepository.findById("u1")).thenReturn(Optional.of(twin));
        ResponseEntity<UserAIMemory> response = controller.getTwin("u1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getTwin_returnsDefault_whenNotExists() {
        when(twinRepository.findById("u1")).thenReturn(Optional.empty());
        ResponseEntity<UserAIMemory> response = controller.getTwin("u1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
        assertThat(response.getBody().getDominantEmotion()).isEqualTo("Neutral");
    }

    @Test
    void updateTwin_updatesAndReturns() {
        UserAIMemory twin = new UserAIMemory();
        when(twinRepository.findById("u1")).thenReturn(Optional.of(twin));

        ResponseEntity<UserAIMemory> response = controller.updateTwin("u1");

        verify(twinService).update("u1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }
}
