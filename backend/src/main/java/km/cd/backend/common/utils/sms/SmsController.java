package km.cd.backend.common.utils.sms;

import lombok.AllArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/sms")
@AllArgsConstructor
public class SmsController {
    
    private final SmsService smsService;
    
    @PostMapping("/send")
    public ResponseEntity<String> sendSms(@RequestBody SmsCertificationRequest requestDto) {
        return ResponseEntity.ok(smsService.sendSms(requestDto));
    }
    
    //인증번호 확인   "phone": "010-6636-9947",
    @PostMapping("/confirm")
    public ResponseEntity<String> SmsVerification(@RequestBody SmsCertificationRequest requestDto) {
        return ResponseEntity.ok(smsService.verifySms(requestDto));
    }
    
}
