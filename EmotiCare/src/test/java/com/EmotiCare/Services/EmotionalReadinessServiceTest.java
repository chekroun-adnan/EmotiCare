package com.EmotiCare.Services;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class EmotionalReadinessServiceTest {

    private final EmotionalReadinessService service = new EmotionalReadinessService();

    @Test
    void detect_detectsListen() {
        assertThat(service.detect("just venting")).isEqualTo(EmotionalReadinessService.Mode.LISTEN);
    }

    @Test
    void detect_detectsAdvise() {
        assertThat(service.detect("what should i do?")).isEqualTo(EmotionalReadinessService.Mode.ADVISE);
    }

    @Test
    void detect_detectsSupport() {
        assertThat(service.detect("I feel bad")).isEqualTo(EmotionalReadinessService.Mode.SUPPORT);
    }
}
