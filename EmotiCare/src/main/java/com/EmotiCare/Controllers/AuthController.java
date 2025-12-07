package com.EmotiCare.Controllers;


import com.EmotiCare.Entities.Role;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import com.EmotiCare.Security.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
@Tag(name = "User Controller", description = "Operations about users")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    @Operation(summary = "Register User", description = "Save a new user to the database")
    public ResponseEntity<String> register(@RequestBody User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email Already Exists");
        }
        user.setEmail(user.getEmail());
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.USER);
        userRepository.save(user);
        return ResponseEntity.status(HttpStatus.CREATED).body("User Registered Successfully");
    }


    @PostMapping("/login")
    @Operation(summary = "Give Acces to user", description = "Returns access and refresh tokens upon successful authentication")
    public ResponseEntity<?> login(@RequestParam String email, @RequestParam String password) {
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(email, password));

        String accessToken = jwtUtil.generateAccessToken(email);
        String refreshToken = jwtUtil.generateRefreshToken(email);

        return ResponseEntity.ok(Map.of("accessToken", accessToken, "refreshToken", refreshToken));
    }
}
