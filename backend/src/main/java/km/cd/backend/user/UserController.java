package km.cd.backend.user;

import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.user.dto.UserResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<UserResponse> me(@AuthenticationPrincipal PrincipalDetails principalDetails) {
        Long userId = principalDetails.getUserId();
        User user = userService.findById(userId);
        UserResponse userResponse = UserMapper.INSTANCE.userToUserResponse(user);
        return ResponseEntity.ok(userResponse);
    }

    @GetMapping("/me/challenges")
    public ResponseEntity<List<ChallengeSimpleResponse>> myChallenges(
            @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        Long userId = principalDetails.getUserId();
        List<ChallengeSimpleResponse> challengeSimpleResponses = userService.getChallengesByUserId(userId);
        return ResponseEntity.ok(challengeSimpleResponses);
    }

}
