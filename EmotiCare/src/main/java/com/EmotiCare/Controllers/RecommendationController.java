package com.EmotiCare.Controllers;

import com.EmotiCare.AI.AIRecommendationService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/recommendations")
public class RecommendationController {
    private final AIRecommendationService service;
    public RecommendationController(AIRecommendationService service){ this.service = service; }

    @GetMapping("/activities")
    public List<String> recommend(@RequestParam String userId){
        return service.recommendActivities(userId);
    }
}
