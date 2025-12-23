package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProactiveAIServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private GroqService groqService;

    @InjectMocks
    private ProactiveAIService service;

    @Test
    void dailyCheckInAllUsers_callsAskForUsers() {
        User u = new User();
        u.setId("u1");
        when(userRepository.findAll()).thenReturn(List.of(u));

        service.dailyCheckInAllUsers();

        verify(groqService).ask(any(), eq("u1"), any());
    }

    @Test
    void manualCheckIn_callsAsk() {
        when(groqService.ask(any(), eq("u1"), any())).thenReturn("Reply");
        String result = service.manualCheckIn("u1");
        assertThat(result).isEqualTo("Reply");
    }
}
