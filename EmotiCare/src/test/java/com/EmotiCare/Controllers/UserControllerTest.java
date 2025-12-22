package com.EmotiCare.Controllers;

import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import com.EmotiCare.Services.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.security.Principal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    @Test
    void getCurrentUser_returnsUser() {
        Principal principal = mock(Principal.class);
        when(principal.getName()).thenReturn("test@example.com");

        User user = new User();
        user.setEmail("test@example.com");
        when(userRepository.findByEmail("test@example.com")).thenReturn(Optional.of(user));

        User result = userController.getCurrentUser(principal);
        assertThat(result.getEmail()).isEqualTo("test@example.com");
    }

    @Test
    void updateUser_returnsOk() {
        User u = new User();
        u.setEmail("t@t.com");
        when(userService.updateUser(u)).thenReturn(u);

        ResponseEntity<?> response = userController.updateUser(u);
        assertThat(response.getStatusCodeValue()).isEqualTo(200);
    }
}
