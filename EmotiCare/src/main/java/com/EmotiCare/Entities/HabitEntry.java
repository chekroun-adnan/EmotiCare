package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Document(collection = "habit_entries")
public class HabitEntry {

    @Id
    private String id;
    private LocalDate date;
    private double value;

    @DBRef
    private Habit habit;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public double getValue() { return value; }
    public void setValue(double value) { this.value = value; }

    public Habit getHabit() { return habit; }
    public void setHabit(Habit habit) { this.habit = habit; }
}
