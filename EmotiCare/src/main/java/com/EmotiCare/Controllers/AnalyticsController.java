package com.EmotiCare.Controllers;

import com.EmotiCare.AI.AIAnalyticsService;
import com.EmotiCare.Entities.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/analytics")
public class AnalyticsController {
    @Autowired
    private AIAnalyticsService service;

    @GetMapping("/weekly-summary")
    public String weeklySummary(@RequestParam User userId){
        return service.generateWeeklySummary(userId);
    }
}
