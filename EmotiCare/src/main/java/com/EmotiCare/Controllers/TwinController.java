package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.UserAIMemory;
import com.EmotiCare.Repositories.UserAIMemoryRepository;
import com.EmotiCare.Services.DigitalTwinService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/twin")
@RequiredArgsConstructor
public class TwinController {

    private final UserAIMemoryRepository twinRepository;
    private final DigitalTwinService twinService;

    @GetMapping("/{userId}")
    public ResponseEntity<UserAIMemory> getTwin(@PathVariable String userId) {
        Optional<UserAIMemory> twin = twinRepository.findById(userId);
        if (twin.isPresent()) {
            return ResponseEntity.ok(twin.get());
        } else {
            // Return a default twin if none exists
            UserAIMemory defaultTwin = new UserAIMemory();
            defaultTwin.setUserId(userId);
            defaultTwin.setDominantEmotion("Neutral");
            defaultTwin.setStressTrigger("Unknown");
            defaultTwin.setPreferredCoping("Unknown");
            return ResponseEntity.ok(defaultTwin);
        }
    }

    @PostMapping("/update/{userId}")
    public ResponseEntity<UserAIMemory> updateTwin(@PathVariable String userId) {
        twinService.update(userId);
        Optional<UserAIMemory> updatedTwin = twinRepository.findById(userId);
        return updatedTwin.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}

