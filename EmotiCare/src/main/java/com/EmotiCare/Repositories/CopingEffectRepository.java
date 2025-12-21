package com.EmotiCare.Repositories;

import com.EmotiCare.Entities.CopingEffect;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface CopingEffectRepository extends MongoRepository<CopingEffect, String> {
    List<CopingEffect> findByUserIdAndCoping(String userId, String coping);
}
