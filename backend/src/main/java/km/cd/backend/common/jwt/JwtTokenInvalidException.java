package km.cd.backend.common.jwt;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;

/**
 * 토큰이 유효하지 않을때 발생하는 Exception
 * @see JwtTokenProvider#validateToken(String)
 */
public class JwtTokenInvalidException extends CustomException {

    // 자주 발생할 수 있는 Exception 이기 때문에 Singleton 화 했습니다.
    public static final JwtTokenInvalidException INSTANCE = new JwtTokenInvalidException();

    private JwtTokenInvalidException() {
        super(ExceptionCode.TOKEN_NOT_VALID);
    }

}
