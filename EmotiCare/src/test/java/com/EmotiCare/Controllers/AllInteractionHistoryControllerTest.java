package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.AllInteractionHistory;
import com.EmotiCare.Services.AllInteractionHistoryService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AllInteractionHistoryControllerTest {

    @Mock
    private AllInteractionHistoryService historyService;

    @InjectMocks
    private AllInteractionHistoryController controller;

    @Test
    void createHistory_returnsOk() {
        when(historyService.createEmptyHistory("u1")).thenReturn(new AllInteractionHistory());
        ResponseEntity<AllInteractionHistory> res = controller.createHistory("u1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getHistory_returnsOk() {
        when(historyService.getHistory("u1")).thenReturn(Optional.of(new AllInteractionHistory()));
        ResponseEntity<?> res = controller.getHistory("u1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void addMood_returnsOk() {
        when(historyService.addMoodToHistory("h1", "m1")).thenReturn(new AllInteractionHistory());
        ResponseEntity<AllInteractionHistory> res = controller.addMood("h1", "m1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void delete_deletes() {
        ResponseEntity<String> res = controller.delete("h1");
        verify(historyService).deleteHistory("h1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }
}
