package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.ConversationMessage;
import com.EmotiCare.Services.ConversationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/conversation")
public class ConversationController {

    private final ConversationService conversationService;

    public ConversationController(ConversationService conversationService) {
        this.conversationService = conversationService;
    }

    @PostMapping("/send")
    public ResponseEntity<ConversationService.ConversationResult> handleMessage(
            @RequestParam String userId,
            @RequestParam String message
    ) {
        ConversationService.ConversationResult result = conversationService.handleIncomingMessage(userId, message);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/save")
    public ResponseEntity<ConversationMessage> saveUserMessage(
            @RequestParam String userId,
            @RequestParam String content
    ) {
        return ResponseEntity.ok(conversationService.saveUserMessage(userId, content));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ConversationMessage> getMessage(@PathVariable String id) {
        return conversationService.getMessage(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<ConversationMessage>> getConversation(@PathVariable String userId) {
        return ResponseEntity.ok(conversationService.getConversationForUser(userId));
    }
}
