package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.CommunityPost;
import com.EmotiCare.Entities.Role;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.CommunityPostRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class CommunityService {

    private final CommunityPostRepository communityPostRepository;
    private final GroqService groqService;
    private final AuthService authService;

    public CommunityService(CommunityPostRepository communityPostRepository, GroqService groqService, AuthService authService) {
        this.communityPostRepository = communityPostRepository;
        this.groqService = groqService;
        this.authService = authService;
    }

    public CommunityPost createPost(String userId, String text) {
        CommunityPost p = new CommunityPost();
        p.setUserId(userId);
        p.setText(text);
        p.setTimestamp(LocalDateTime.now());
        return communityPostRepository.save(p);
    }

    public List<CommunityPost> getAllPosts() {
        User currentUser = authService.getCurrentUser();
        if (currentUser == null || currentUser.getRole() != Role.USER) {
            throw new RuntimeException("Unauthorized access to all posts");
        }
        return communityPostRepository.findAll();
    }

    public List<CommunityPost> getPostsByUser(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw  new RuntimeException("Unauthorized access to this posts");
        }
        return communityPostRepository.findByUserId(userId);
    }

    public Optional<CommunityPost> getPost(String userId, String id) {
        
        return communityPostRepository.findById(id);
    }

    public void deletePost(String id) {
        communityPostRepository.deleteById(id);
    }

    public String moderatePostWithAI(String userId, String postText) {
        String system = "You are a content moderator. Evaluate if the following post contains harmful content (violence, self-harm instructions, hate). Return 'allow' or 'block' and a short reason.";
        return groqService.ask(system, userId, postText);
    }
}
