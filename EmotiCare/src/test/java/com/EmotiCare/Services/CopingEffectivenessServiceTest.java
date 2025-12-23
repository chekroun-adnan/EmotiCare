package com.EmotiCare.Services;

import com.EmotiCare.Entities.CopingEffect;
import com.EmotiCare.Repositories.CopingEffectRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import java.util.List;

@ExtendWith(MockitoExtension.class)
class CopingEffectivenessServiceTest {

    @Mock
    private CopingEffectRepository repo;

    @InjectMocks
    private CopingEffectivenessService service;

    @Test
    void record_savesNewEffect_whenNotFound() {
        when(repo.findByUserIdAndCoping("u1", "music")).thenReturn(java.util.Collections.emptyList());
        service.record("u1", "music", true);
        verify(repo).save(any(CopingEffect.class));
    }

    @Test
    void record_updatesEffect_whenFound() {
        CopingEffect existing = new CopingEffect();
        existing.setAttempts(1);
        existing.setSuccess(0);
        when(repo.findByUserIdAndCoping("u1", "music")).thenReturn(List.of(existing));

        service.record("u1", "music", true);

        assertThat(existing.getAttempts()).isEqualTo(2);
        assertThat(existing.getSuccess()).isEqualTo(1);
        verify(repo).save(existing);
    }

    @Test
    void effectiveness_calculatesCorrectly() {
        CopingEffect ce = new CopingEffect();
        ce.setAttempts(10);
        ce.setSuccess(5);
        assertThat(service.effectiveness(ce)).isEqualTo(0.5);
    }
}
