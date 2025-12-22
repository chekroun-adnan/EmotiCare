package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.TherapySession;
import com.EmotiCare.Services.TherapySessionService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TherapySessionControllerTest {

    @Mock
    private TherapySessionService sessionService;

    @InjectMocks
    private TherapySessionController controller;

    @Test
    void startSession_returnsOk() {
        TherapySession s = new TherapySession();
        when(sessionService.startSession("u1")).thenReturn(s);
        ResponseEntity<TherapySession> res = controller.startSession("u1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getSession_returnsOk() {
        when(sessionService.getSession("s1")).thenReturn(Optional.of(new TherapySession()));
        ResponseEntity<TherapySession> res = controller.getSession("s1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }
}
