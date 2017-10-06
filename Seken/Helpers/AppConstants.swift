//
//  AppConstants.swift
//  Seken
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
struct Constants {
    
    static let AppleAppID = "1030365320"
    
    struct AppFlyersKeys{
        static let DevKey = "49ALdsK3P5qDuRYDKZkQXM"
    }
    
    struct GoogleSignupKeys{
        static let ClientID = "153995361747-klet1e2nrmm6vpfm02ll5ok6j73smp56.apps.googleusercontent.com"
    }
    
    struct FaceBookSignuppKeys{
        static let FBID = "fb291799221282267"
    }
    
    struct APIS {
        
        static let CLIENT_KEY = "iOSApp"
        struct SIGNUPS {
            static let LOGIN_EMAIL = "auth/basic"
            static let LOGIN_PHONE = "auth/basic?"
            static let LOGIN_FACEBOOK = "auth/facebook"
            static let LOGIN_GMAIL = "auth/google"
            static let REGISTER =  "auth/basic/registration"
            static let GENERATE_OTP =  "auth/otp"
            static let VERIFY_OTP = "auth/otp/verify"
            static let FORGOT_PASSWORD = "profile/password/forgot"
            static let CHANGE_PASSWORD = "profile/password/reset"
        }
        
    }
    
}
