package com.EmotiCare.Services;

import org.springframework.stereotype.Service;

@Service
public class EmotionalReadinessService {

    public enum Mode { LISTEN, SUPPORT, ADVISE }

    public Mode detect(String msg) {
        String m = msg.toLowerCase();

        if (m.contains("just needed to say")
                || m.contains("don't want advice")
                || m.contains("just venting"))
            return Mode.LISTEN;

        if (m.contains("?") || m.contains("what should i do"))
            return Mode.ADVISE;

        return Mode.SUPPORT;
    }
}

