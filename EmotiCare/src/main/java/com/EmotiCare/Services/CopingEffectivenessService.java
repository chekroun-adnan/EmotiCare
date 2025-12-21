package com.EmotiCare.Services;

import java.util.List;

import com.EmotiCare.Entities.CopingEffect;
import com.EmotiCare.Repositories.CopingEffectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CopingEffectivenessService {

    private final CopingEffectRepository repo;

    public void record(String userId, String coping, boolean improved) {
        List<CopingEffect> list = repo.findByUserIdAndCoping(userId, coping);
        CopingEffect ce = list.isEmpty() ? null : list.get(0);
        if (ce == null) {
            ce = new CopingEffect();
        }

        ce.setUserId(userId);
        ce.setCoping(coping);
        ce.setAttempts(ce.getAttempts() + 1);

        if (improved)
            ce.setSuccess(ce.getSuccess() + 1);

        repo.save(ce);
    }

    public double effectiveness(CopingEffect ce) {
        return ce.getAttempts() == 0 ? 0 : (double) ce.getSuccess() / ce.getAttempts();
    }
}
