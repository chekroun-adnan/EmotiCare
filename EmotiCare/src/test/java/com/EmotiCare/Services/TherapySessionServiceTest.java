package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Entities.TherapySession;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.ConversationRepository;
import com.EmotiCare.Repositories.TherapySessionRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TherapySessionServiceTest {

    @Mock
    private TherapySessionRepository therapySessionRepository;

    @Mock
    private ConversationRepository conversationRepository;

    @Mock
    private GroqService groqService;

    @Mock
    private AuthService authService;

    @InjectMocks
    private TherapySessionService therapySessionService;

    @Test
    void startSession_savesSession() {
        when(therapySessionRepository.save(any(TherapySession.class))).thenAnswer(i -> i.getArgument(0));

        TherapySession result = therapySessionService.startSession("user1");
        assertThat(result.getUserId()).isEqualTo("user1");
        assertThat(result.getStartTime()).isNotNull();
    }

    @Test
    void endSession_endsSession() {
        TherapySession session = new TherapySession();
        session.setId("s1");
        session.setUserId("user1");

        when(therapySessionRepository.findById("s1")).thenReturn(Optional.of(session));
        when(therapySessionRepository.save(any(TherapySession.class))).thenAnswer(i -> i.getArgument(0));
        when(conversationRepository.findByUserId("user1")).thenReturn(List.of());

        TherapySession result = therapySessionService.endSession("s1");
        assertThat(result.getEndTime()).isNotNull();
    }

    @Test
    void getSession_returnsSession_whenAuthorized() {
        User user = new User();
        user.setId("user1");
        when(authService.getCurrentUser()).thenReturn(user);

        TherapySession session = new TherapySession();
        session.setUserId("user1");
        when(therapySessionRepository.findById("s1")).thenReturn(Optional.of(session));

        Optional<TherapySession> result = therapySessionService.getSession("s1");
        assertThat(result).isPresent();
    }

    @Test
    void summarizeSessionWithAI_returnsSummary() {
        User user = new User();
        user.setId("user1");
        when(authService.getCurrentUser()).thenReturn(user);

        TherapySession session = new TherapySession();
        session.setUserId("user1");
        session.setMessageIds(List.of("m1"));
        when(therapySessionRepository.findById("s1")).thenReturn(Optional.of(session));

        ConversationMessage msg = new ConversationMessage();
        msg.setId("m1");
        msg.setContent("Hello");
        msg.setTimestamp(LocalDateTime.now());
        when(conversationRepository.findAllById(List.of("m1"))).thenReturn(List.of(msg));

        when(groqService.ask(any(), eq("user1"), any())).thenReturn("Summary");

        String result = therapySessionService.summarizeSessionWithAI("s1");
        assertThat(result).isEqualTo("Summary");
    }
}
