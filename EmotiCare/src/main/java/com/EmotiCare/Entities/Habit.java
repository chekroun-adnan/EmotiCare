package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "habits")
public class Habit {

    @Id
    private String id;
    private String name;
    private String type;
    private int goal;

    @DBRef
    private User user;

    @DBRef
    private List<HabitEntry> entries;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getGoal() { return goal; }
    public void setGoal(int goal) { this.goal = goal; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public List<HabitEntry> getEntries() { return entries; }
    public void setEntries(List<HabitEntry> entries) { this.entries = entries; }
}
