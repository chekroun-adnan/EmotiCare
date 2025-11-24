package com.EmotiCare.Services;

import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private final UserRepository userRepository;


    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User updateUser(User user) {
        Optional<User> existingUserOpt = userRepository.findByEmail(user.getEmail());
        if (existingUserOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        User existingUser = existingUserOpt.get();
        existingUser.setFirstName(user.getFirstName());
        existingUser.setLastName(user.getLastName());
        existingUser.setEmail(user.getEmail());
        existingUser.setAge(user.getAge());
        existingUser.setPassword(user.getPassword());
        return userRepository.save(existingUser);
    }
}
