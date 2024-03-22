package km.cd.backend.user;

import km.cd.backend.jwt.PrincipalDetails;
import km.cd.backend.user.dto.UserResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<UserResponse> me(@AuthenticationPrincipal PrincipalDetails principalDetails) {
        String email = principalDetails.getEmail();
        User user = userService.findByEmail(email);
        UserResponse userResponse = UserMapper.INSTANCE.userToUserResponse(user);
        return ResponseEntity.ok(userResponse);
    }

}
