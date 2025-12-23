package com.EmotiCare.ai;

import org.junit.jupiter.api.Test;
import java.util.Map;
import static org.assertj.core.api.Assertions.assertThat;

class UserDataServiceImplTest {

    private final UserDataServiceImpl service = new UserDataServiceImpl();

    @Test
    void getUserData_returnsPlaceholderData() {
        Map<String, Object> data = service.getUserData("u1");
        assertThat(data).containsKey("moodHistory");
        assertThat(data).containsKey("journalEntries");
    }
}
