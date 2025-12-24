package com.EmotiCare.Services;

import com.EmotiCare.ai.GroqService;
import com.EmotiCare.Entities.CommunityPost;
import com.EmotiCare.Entities.Role;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.CommunityPostRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CommunityServiceTest {

    @Mock
    private CommunityPostRepository communityPostRepository;
    @Mock
    private GroqService groqService;
    @Mock
    private AuthService authService;

    @InjectMocks
    private CommunityService service;

    @Test
    void createPost_savesPost() {
        when(communityPostRepository.save(any())).thenReturn(new CommunityPost());
        service.createPost("u1", "text");
        verify(communityPostRepository).save(any());
    }

    @Test
    void getAllPosts_returnsPosts_whenUser() {
        User user = new User();
        user.setRole(Role.USER);
        when(authService.getCurrentUser()).thenReturn(user);
        when(communityPostRepository.findAll()).thenReturn(List.of(new CommunityPost()));

        List<CommunityPost> result = service.getAllPosts();
        assertThat(result).hasSize(1);
    }

    @Test
    void getPostsByUser_returnsPosts_whenAuthorized() {
        User user = new User();
        user.setId("u1");
        when(authService.getCurrentUser()).thenReturn(user);
        when(communityPostRepository.findByUserId("u1")).thenReturn(List.of(new CommunityPost()));

        List<CommunityPost> result = service.getPostsByUser("u1");
        assertThat(result).hasSize(1);
    }
}
