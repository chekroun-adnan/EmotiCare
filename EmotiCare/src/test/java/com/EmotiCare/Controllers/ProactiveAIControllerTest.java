package com.EmotiCare.Controllers;

import com.EmotiCare.Services.ProactiveAIService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProactiveAIControllerTest {

    @Mock
    private ProactiveAIService service;

    @InjectMocks
    private ProactiveAIController controller;

    @Test
    void manualCheckIn_returnsReply() {
        when(service.manualCheckIn("u1")).thenReturn("Reply");
        ResponseEntity<String> response = controller.manualCheckIn("u1");
        assertThat(response.getBody()).isEqualTo("Reply");
    }
}
