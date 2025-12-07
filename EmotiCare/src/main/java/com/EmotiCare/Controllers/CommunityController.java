package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.CommunityPost;
import com.EmotiCare.Services.CommunityService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/community")
public class CommunityController {

    private final CommunityService communityService;

    public CommunityController(CommunityService communityService) {
        this.communityService = communityService;
    }


    @PostMapping("/create")
    public ResponseEntity<CommunityPost> createPost(
            @RequestParam String userId,
            @RequestParam String text) {

        CommunityPost created = communityService.createPost(userId, text);
        return ResponseEntity.ok(created);
    }


    @GetMapping("/all")
    public ResponseEntity<List<CommunityPost>> getAllPosts() {
        return ResponseEntity.ok(communityService.getAllPosts());
    }


    @GetMapping("/user/{userId}")
    public ResponseEntity<List<CommunityPost>> getUserPosts(@PathVariable String userId) {
        return ResponseEntity.ok(communityService.getPostsByUser(userId));
    }


    @GetMapping("/{id}")
    public ResponseEntity<?> getPost(@PathVariable String userId, @RequestParam String id) {
        Optional<CommunityPost> p = communityService.getPost(userId,id);

        if (p.isEmpty())
            return ResponseEntity.notFound().build();

        return ResponseEntity.ok(p.get());
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePost(@PathVariable String id) {
        communityService.deletePost(id);
        return ResponseEntity.ok("Post deleted");
    }


    @PostMapping("/moderate")
    public ResponseEntity<String> moderatePost(
            @RequestParam String userId,
            @RequestParam String text) {

        String result = communityService.moderatePostWithAI(userId, text);
        return ResponseEntity.ok(result);
    }
}
