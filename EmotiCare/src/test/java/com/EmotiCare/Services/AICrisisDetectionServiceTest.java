package com.EmotiCare.Services;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class AICrisisDetectionServiceTest {

    private final AICrisisDetectionService service = new AICrisisDetectionService();

    @Test
    void isCrisis_returnsTrue_forCrisisKeywords() {
        assertThat(service.isCrisis("I want to die")).isTrue();
        assertThat(service.isCrisis("kill myself")).isTrue();
        assertThat(service.isCrisis("start feeling sad")).isFalse();
    }

    @Test
    void isCrisis_returnsFalse_forNull() {
        assertThat(service.isCrisis(null)).isFalse();
    }

    @Test
    void getEmergencyMessage_returnsMessage() {
        assertThat(service.getEmergencyMessage()).contains("988");
    }
}
