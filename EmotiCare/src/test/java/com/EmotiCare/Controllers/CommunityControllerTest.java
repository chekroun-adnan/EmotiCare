package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.CommunityPost;
import com.EmotiCare.Services.CommunityService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CommunityControllerTest {

    @Mock
    private CommunityService communityService;

    @InjectMocks
    private CommunityController controller;

    @Test
    void createPost_returnsOk() {
        when(communityService.createPost("u1", "text")).thenReturn(new CommunityPost());
        ResponseEntity<CommunityPost> response = controller.createPost("u1", "text");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getAllPosts_returnsOk() {
        when(communityService.getAllPosts()).thenReturn(List.of(new CommunityPost()));
        ResponseEntity<List<CommunityPost>> response = controller.getAllPosts();
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getUserPosts_returnsOk() {
        when(communityService.getPostsByUser("u1")).thenReturn(List.of(new CommunityPost()));
        ResponseEntity<List<CommunityPost>> response = controller.getUserPosts("u1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void getPost_returnsOk() {
        when(communityService.getPost("u1", "p1")).thenReturn(Optional.of(new CommunityPost()));
        ResponseEntity<?> response = controller.getPost("u1", "p1");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }

    @Test
    void deletePost_deletes() {
        controller.deletePost("p1");
        verify(communityService).deletePost("p1");
    }

    @Test
    void moderatePost_returnsResult() {
        when(communityService.moderatePostWithAI("u1", "text")).thenReturn("Allowed");
        ResponseEntity<String> response = controller.moderatePost("u1", "text");
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
        assertThat(response.getBody()).isEqualTo("Allowed");
    }
}
