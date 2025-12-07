package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
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

    private List<String> moodEntryIds = new ArrayList<>();
    private List<String> journalEntryIds = new ArrayList<>();
    private List<String> conversationMessageIds = new ArrayList<>();
    private List<String> goalIds = new ArrayList<>();
    private List<String> habitIds = new ArrayList<>();
    private List<String> therapySessionIds = new ArrayList<>();
    private List<String> weeklySummaryIds = new ArrayList<>();
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
    public List<String> getMoodEntryIds() { return moodEntryIds; }
    public List<String> getJournalEntryIds() { return journalEntryIds; }
    public List<String> getConversationMessageIds() { return conversationMessageIds; }
    public List<String> getGoalIds() { return goalIds; }
    public List<String> getHabitIds() { return habitIds; }
    public List<String> getTherapySessionIds() { return therapySessionIds; }
    public List<String> getWeeklySummaryIds() { return weeklySummaryIds; }

    public boolean isAdmin() {
        return this.role == Role.ADMIN;
    }
}
