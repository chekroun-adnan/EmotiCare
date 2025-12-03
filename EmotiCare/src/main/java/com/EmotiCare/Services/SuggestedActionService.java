package com.EmotiCare.Services;

import com.EmotiCare.AI.GroqService;
import com.EmotiCare.Entities.SuggestedAction;
import com.EmotiCare.Repositories.SuggestedActionRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class SuggestedActionService {

    private final SuggestedActionRepository suggestedActionRepository;
    private final GroqService groqService;

    public SuggestedActionService(SuggestedActionRepository suggestedActionRepository,
                                  GroqService groqService) {
        this.suggestedActionRepository = suggestedActionRepository;
        this.groqService = groqService;
    }

    public SuggestedAction save(SuggestedAction action) {
        return suggestedActionRepository.save(action);
    }

    public List<SuggestedAction> getForUser(String userId) {
        return suggestedActionRepository.findByUserId(userId);
    }

    public void delete(String id) {
        suggestedActionRepository.deleteById(id);
    }

    public String generateAndSaveActions(String userId, String context) {
        Optional<Map<String, Object>> maybe = groqService.requestJsonActions(userId, context);
        if (maybe.isEmpty()) {
            return "No structured actions returned by AI.";
        }
        Map<String, Object> map = maybe.get();
        Object actionsObj = map.get("actions");
        if (!(actionsObj instanceof List)) return "AI returned malformed actions.";

        List<?> actions = (List<?>) actionsObj;
        for (Object o : actions) {
            if (!(o instanceof Map)) continue;
            Map<?, ?> m = (Map<?, ?>) o;

            Object categoryObj = m.get("action");
            String category = categoryObj != null ? categoryObj.toString() : "general";

            Object descObj = m.get("description");
            String description = descObj != null ? descObj.toString() : "";

            SuggestedAction sa = new SuggestedAction();
            sa.setUserId(userId);
            sa.setCategory(category);
            sa.setDescription(description);
            sa.setDone(false);
            suggestedActionRepository.save(sa);
        }
        return "Saved " + actions.size() + " suggested actions.";

    }
}
