package km.cd.backend.oauth2.attributes;

import java.util.Map;

public class OAuth2AttributesFactory {

    public static OAuth2Attributes getOauth2Attributes(String registrationId, Map<String, Object> attributes, String userNameAttributeName) {
        switch (registrationId) {
            case "google":
                return GoogleOAuth2Attributes.builder().attributes(attributes).userNameAttributeName(userNameAttributeName).build();
            default:
                throw new IllegalArgumentException();
        }
    }

}
