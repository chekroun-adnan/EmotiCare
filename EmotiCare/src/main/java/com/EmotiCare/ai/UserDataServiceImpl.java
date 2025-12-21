package com.EmotiCare.ai;

import com.EmotiCare.Repositories.UserDataService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserDataServiceImpl implements UserDataService {

    @Override
    public Map<String, Object> getUserData(String userId) {

        // TODO: replace with real Mongo queries
        Map<String, Object> data = new HashMap<>();

        data.put("moodHistory", "[]");
        data.put("journalEntries", "[]");
        data.put("habits", "[]");
        data.put("goals", "[]");
        data.put("pastMessages", "[]");

        return data;
    }


}
