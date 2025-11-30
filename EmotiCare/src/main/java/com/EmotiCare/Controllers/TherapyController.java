package com.EmotiCare.Controllers;


import com.EmotiCare.AI.GroqService;
import com.EmotiCare.DTO.UserMessageDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/therapy")
public class TherapyController {

    private final GroqService groqService;

    public TherapyController(GroqService groqService) {
        this.groqService = groqService;
    }

    @PostMapping("/{userId}/message")
    public ResponseEntity<?> sendMessage(@PathVariable String userId, @RequestBody UserMessageDTO dto) {
        String reply = groqService.generateTherapyMessageAndSave(userId, dto.getMessage());
        return ResponseEntity.ok(reply);
    }
}
