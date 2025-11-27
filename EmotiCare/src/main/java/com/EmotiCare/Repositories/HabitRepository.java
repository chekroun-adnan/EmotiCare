package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.Habit;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface HabitRepository extends MongoRepository<Habit, String> {

    List<Habit> findByUserId(String id);
}
