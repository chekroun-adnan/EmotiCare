package com.EmotiCare.Services;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class AISentimentServiceTest {

    private final AISentimentService service = new AISentimentService();

    @Test
    void analyzeSentiment_detectsEmotions() {
        assertThat(service.analyzeSentiment("I am so happy!")).isEqualTo("joyful");
        assertThat(service.analyzeSentiment("I feel sad today")).isEqualTo("sad");
        assertThat(service.analyzeSentiment("I am angry")).isEqualTo("angry");
        assertThat(service.analyzeSentiment("Nothing special")).isEqualTo("neutral");
    }

    @Test
    void addKeyword_updatesDetection() {
        service.addKeyword("custom", "foo");
        assertThat(service.analyzeSentiment("This is foo")).isEqualTo("custom");
    }
}
