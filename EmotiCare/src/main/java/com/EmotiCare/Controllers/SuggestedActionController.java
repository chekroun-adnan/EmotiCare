package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.SuggestedAction;
import com.EmotiCare.Services.SuggestedActionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/actions")
public class SuggestedActionController {

    private final SuggestedActionService actionService;

    public SuggestedActionController(SuggestedActionService actionService) {
        this.actionService = actionService;
    }

    @PostMapping
    public ResponseEntity<SuggestedAction> save(@RequestBody SuggestedAction action) {
        return ResponseEntity.ok(actionService.save(action));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<SuggestedAction>> getForUser(@PathVariable String userId) {
        return ResponseEntity.ok(actionService.getForUser(userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable String userId, @RequestParam String id) {
        actionService.delete(userId,id);
        return ResponseEntity.ok("Action deleted");
    }

    @PostMapping("/generate")
    public ResponseEntity<String> generateAndSave(
            @RequestParam String userId,
            @RequestParam String context) {

        String result = actionService.generateAndSaveActions(userId, context);
        return ResponseEntity.ok(result);
    }
}
