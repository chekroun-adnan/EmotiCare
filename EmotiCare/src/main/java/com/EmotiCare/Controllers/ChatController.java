package com.EmotiCare.Controllers;

import com.EmotiCare.DTO.ChatResponse;
import org.springframework.web.bind.annotation.*;


import com.EmotiCare.Services.ChatOrchestratorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatOrchestratorService chatService;

    @PostMapping("/send")
    public ResponseEntity<ChatResponse> sendMessage(
            @RequestParam String userId,
            @RequestBody String message
    ) {
        ChatResponse response =
                chatService.handleChat(userId, message);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/session/start")
    public ResponseEntity<?> startSession(@RequestParam String userId) {
        return ResponseEntity.ok(
                chatService.startSession(userId)
        );
    }

    @GetMapping("/session/{id}/summary")
    public ResponseEntity<String> summarizeSession(@PathVariable String id) {
        return ResponseEntity.ok(
                chatService.summarizeSession(id)
        );
    }
}
