package com.EmotiCare.Controllers;


import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import com.EmotiCare.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private final UserRepository userRepository;

    @Autowired
    private final UserService userService;

    public UserController(UserRepository userRepository, UserService userService) {
        this.userRepository = userRepository;
        this.userService = userService;
    }

    @GetMapping("/me")
    public User getCurrentUser(Principal principal) {
        return userRepository.findByEmail(principal.getName())
                .orElseThrow(()-> new RuntimeException("User Not Found"));
    }

    @PutMapping("/update")
    public ResponseEntity<?> updateUser(@RequestBody User user) {
        try {
            User updatedUser = userService.updateUser(user);
            Map<String, Object> response = new HashMap<>();
            response.put("id", updatedUser.getId());
            response.put("firstName", updatedUser.getFirstName());
            response.put("lastName", updatedUser.getLastName());
            response.put("email", updatedUser.getEmail());
            response.put("age", updatedUser.getAge());
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("User Not Found");
        }
    }
}
