package km.cd.backend.common.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

@Component
public class JwtTokenProvider {

    private final Key jwtSecret;
    private final long accessTokenExpirationInMs;
    private final long refreshTokenExpirationInMs;

    private static final String CLAIM_EMAIL = "email";
    private static final String CLAIM_NAME = "name";
    private static final String CLAIM_AUTHORITIES = "authorities";
    private static final String DELIMITER = ",";

    public JwtTokenProvider(
            @Value("${jwt.secret}") String jwtSecretStr,
            @Value("${jwt.ac_expiration_in_ms}") long accessTokenExpirationInMs,
            @Value("${jwt.rf_expiration_in_ms}") long refreshTokenExpirationInMs
    ) {
        this.jwtSecret = Keys.hmacShaKeyFor(jwtSecretStr.getBytes());
        this.accessTokenExpirationInMs = accessTokenExpirationInMs;
        this.refreshTokenExpirationInMs = refreshTokenExpirationInMs;
    }

    public String generateAccessToken(Long userId, String email, String name, Collection<? extends GrantedAuthority> authorities) {
        String authoritiesStr = authorities.stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(DELIMITER));

        long now = System.currentTimeMillis();

        return Jwts.builder()
                .setSubject(userId.toString())
                .claim(CLAIM_EMAIL, email)
                .claim(CLAIM_NAME, name)
                .claim(CLAIM_AUTHORITIES, authoritiesStr)
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + accessTokenExpirationInMs))
                .signWith(jwtSecret, SignatureAlgorithm.HS512)
                .compact();
    }

    public String generateRefreshToken(Long userId) {
        long now = System.currentTimeMillis();

        return Jwts.builder()
                .setSubject(userId.toString())
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + refreshTokenExpirationInMs))
                .signWith(jwtSecret, SignatureAlgorithm.HS512)
                .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(jwtSecret).build().parseClaimsJws(token);
            return true;
        } catch (JwtException e) {
            throw JwtTokenInvalidException.INSTANCE;
        }
    }

    /**
     * DB 조회가 이뤄진다면 JWT 토큰의 장점을 얻어가지 못한다.
     * @link https://velog.io/@tlatldms/%EC%84%9C%EB%B2%84%EA%B0%9C%EB%B0%9C%EC%BA%A0%ED%94%84-Spring-security-refreshing-JWT-DB%EC%A0%91%EA%B7%BC%EC%97%86%EC%9D%B4-%EC%9D%B8%EC%A6%9D%EA%B3%BC-%ED%8C%8C%EC%8B%B1%ED%95%98%EA%B8%B0
    */
    public Authentication getAuthentication(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(jwtSecret)
                .build()
                .parseClaimsJws(token)
                .getBody();

        Long userId = Long.valueOf(claims.getSubject());
        String email = claims.get(CLAIM_EMAIL, String.class);
        String name = claims.get(CLAIM_NAME, String.class);
        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get(CLAIM_AUTHORITIES).toString().split(DELIMITER))
                        .map(SimpleGrantedAuthority::new)
                        .collect(Collectors.toList());

        PrincipalDetails principleDetails = new PrincipalDetails(userId, email, name, authorities);
        return new UsernamePasswordAuthenticationToken(principleDetails, null, authorities);
    }
}

