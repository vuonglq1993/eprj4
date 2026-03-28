package com.languageapp.language_learning_backend.security;

import java.util.Map;

public class OAuth2UserInfo {

    private final Map<String, Object> attributes;

    public OAuth2UserInfo(Map<String, Object> attributes) {
        this.attributes = attributes;
    }

    public String getId()        { return (String) attributes.get("sub");          }  // Google user ID
    public String getEmail()     { return (String) attributes.get("email");        }
    public String getFirstName() { return (String) attributes.get("given_name");   }
    public String getLastName()  { return (String) attributes.get("family_name");  }
    public String getAvatar()    { return (String) attributes.get("picture");      }
    public Boolean isVerified()  { return (Boolean) attributes.getOrDefault("email_verified", false); }
}
