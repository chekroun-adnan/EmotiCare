package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.Skill;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface SkillRepository extends MongoRepository<Skill, String> {}
