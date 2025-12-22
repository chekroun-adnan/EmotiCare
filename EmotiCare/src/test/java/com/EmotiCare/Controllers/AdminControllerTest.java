package com.EmotiCare.Controllers;

import org.junit.jupiter.api.Test;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

class AdminControllerTest {

    private final AdminController controller = new AdminController();

    @Test
    void getAdminData_returnsData() {
        ResponseEntity<String> res = controller.getAdminData();
        assertThat(res.getBody()).isEqualTo("Secret Admin Data");
    }
}
