package com.EmotiCare.Controllers;


import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/me")
    public User getCurrentUser(Principal principal) {
        return userRepository.findByEmail(principal.getName())
                .orElseThrow(()-> new RuntimeException("User Not Found"));
    }
}
