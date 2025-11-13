package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "user")
public class User {

    @Id
    private String id;
    private String firstName;
    private String lastName;

    @Indexed(unique = true)
    private String email;

    private String password;
    private int age;
    private Role role;

    @DBRef
    private List<MoodEntry> moodEntries;

    @DBRef
    private List<JournalEntry> journalEntries;
    @DBRef
    private List<ConversationMessage> conversationMessages;
    @DBRef
    private List<Goal> goals;
    @DBRef
    private List<MoodForecast> moodForecasts;
    @DBRef
    private List<VoiceEntry> voiceEntries;
    @DBRef
    private List<WeeklySummary> weeklySummaries;
    @DBRef
    private UserEmbedding userEmbedding;

    public User() {}

    public User(String firstName, String lastName, String email, String password, int age, Role role) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.age = age;
        this.role = role;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
}
