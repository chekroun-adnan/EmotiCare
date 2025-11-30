package com.EmotiCare.Controllers;

import com.EmotiCare.AI.AIAnalyticsService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/analytics")
public class AnalyticsController {
    private final AIAnalyticsService service;
    public AnalyticsController(AIAnalyticsService service){ this.service = service; }

    @GetMapping("/weekly-summary")
    public String weeklySummary(@RequestParam String userId){
        return service.generateWeeklySummary(userId);
    }
}
