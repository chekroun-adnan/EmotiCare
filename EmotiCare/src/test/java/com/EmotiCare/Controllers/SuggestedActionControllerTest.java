package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.SuggestedAction;
import com.EmotiCare.Services.SuggestedActionService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SuggestedActionControllerTest {

    @Mock
    private SuggestedActionService actionService;

    @InjectMocks
    private SuggestedActionController controller;

    @Test
    void save_returnsOk() {
        SuggestedAction sa = new SuggestedAction();
        when(actionService.save(sa)).thenReturn(sa);
        ResponseEntity<SuggestedAction> res = controller.save(sa);
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getForUser_returnsList() {
        when(actionService.getForUser("u1")).thenReturn(List.of(new SuggestedAction()));
        ResponseEntity<List<SuggestedAction>> res = controller.getForUser("u1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void delete_deletes() {
        ResponseEntity<String> res = controller.delete("u1", "a1");
        verify(actionService).delete("u1", "a1");
        assertThat(res.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void generateAndSave_returnsResult() {
        when(actionService.generateAndSaveActions("u1", "ctx")).thenReturn("Res");
        ResponseEntity<String> res = controller.generateAndSave("u1", "ctx");
        assertThat(res.getBody()).isEqualTo("Res");
    }
}
