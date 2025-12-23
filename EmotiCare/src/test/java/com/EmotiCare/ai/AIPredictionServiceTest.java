package com.EmotiCare.ai;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AIPredictionServiceTest {

    @Mock
    private GroqService groqService;

    @InjectMocks
    private AIPredictionService service;

    @Test
    void predictNextMood_returnsPrediction() {
        when(groqService.predictMood("system", "msg")).thenReturn("happy");
        String result = service.predictNextMood("msg");
        assertThat(result).isEqualTo("happy");
    }
}
