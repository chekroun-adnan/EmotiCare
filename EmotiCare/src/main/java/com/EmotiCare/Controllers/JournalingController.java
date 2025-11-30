package com.EmotiCare.Controllers;

import com.EmotiCare.AI.AIJournalingService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/journaling")
public class JournalingController {
    private final AIJournalingService service;
    public JournalingController(AIJournalingService service){ this.service = service; }

    @GetMapping("/prompt")
    public String getPrompt(){ return service.generatePrompt(); }
}
