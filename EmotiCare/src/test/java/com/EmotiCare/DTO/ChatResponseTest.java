package com.EmotiCare.DTO;

import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;

class ChatResponseTest {

    @Test
    void crisis_createsCrisisResponse() {
        ChatResponse response = ChatResponse.crisis("Emergency");
        assertThat(response.isCrisis()).isTrue();
        assertThat(response.getReply()).isEqualTo("Emergency");
    }

    @Test
    void normal_createsNormalResponse() {
        ChatResponse response = ChatResponse.normal("Hi", "Neutral", "Recs", null, null, null);
        assertThat(response.isCrisis()).isFalse();
        assertThat(response.getActions()).isNull(); // Wait, actions is a Map, getter might be getActions()
        assertThat(response.getReply()).isEqualTo("Hi");
    }
}
