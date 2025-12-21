package com.EmotiCare.Security;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import static org.assertj.core.api.Assertions.assertThat;

@ExtendWith(MockitoExtension.class)
class JwtUtilTest {

    @InjectMocks
    private JwtUtil jwtUtil;

    private final String secret = "mySuperSecretKeyThatIsAtLeast32BytesLength";

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(jwtUtil, "secret", secret);
    }

    @Test
    void generateAccessToken_createsValidToken() {
        String token = jwtUtil.generateAccessToken("test@example.com");
        assertThat(token).isNotNull();
        assertThat(jwtUtil.extractUsername(token)).isEqualTo("test@example.com");
        assertThat(jwtUtil.validateToken(token)).isTrue();
    }

    @Test
    void generateRefreshToken_createsValidToken() {
        String token = jwtUtil.generateRefreshToken("test@example.com");
        assertThat(token).isNotNull();
        assertThat(jwtUtil.extractUsername(token)).isEqualTo("test@example.com");
    }

    @Test
    void validateToken_returnsFalse_forInvalidToken() {
        assertThat(jwtUtil.validateToken("invalidToken")).isFalse();
    }
}
