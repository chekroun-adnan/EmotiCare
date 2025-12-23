package com.EmotiCare.ai;

import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AIProactiveServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private GroqService groqService;

    @InjectMocks
    private AIProactiveService service;

    @Test
    void dailyCheckIn_sendsMessages() {
        User u = new User();
        u.setId("u1");
        u.setFirstName("Name");
        when(userRepository.findAll()).thenReturn(List.of(u));

        service.dailyCheckIn();

        verify(groqService).generateTherapyMessageAndSave(eq("u1"), anyString());
    }
}
