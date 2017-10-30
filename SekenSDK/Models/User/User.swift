//
//  User.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

public class User : NSObject, NSCoding {
    public var userName:String
    public var id: String
    public var token: String
    public var phone: String
    public var email: String
    public var otpValidated: String
   
    
    private var env:Environment
    
    init(userDetails: Dictionary<String,Any>, environment: Environment) {
        let userDict = (userDetails as NSDictionary)
        
        self.userName = userDict.value(forKeyPath: "user.name") as? String ?? ""
        self.id = userDict.value(forKeyPath: "user.uid") as? String ?? ""
        self.token = userDetails["token"] as? String ?? ""
        SekenAPI.sharedAPI.sessionToken = self.token
        self.phone = userDict.value(forKeyPath: "user.phone") as? String ?? ""
        self.email = userDict.value(forKeyPath: "user.mail") as? String ?? ""
        self.otpValidated = userDict.value(forKeyPath: "user.field_otp_validated") as? String ?? ""
        self.env = environment
        
        SekenAPI.sharedAPI.env = self.env
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
       self.otpValidated = aDecoder.decodeObject(forKey: "field_otp_validated") as? String ?? ""
        self.env = Environment(rawValue: aDecoder.decodeObject(forKey: "env") as? Int ?? aDecoder.decodeInteger(forKey: "env")) ?? .prod
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userName, forKey:"userName")
        aCoder.encode(self.id, forKey:"id")
        aCoder.encode(self.token, forKey:"token")
        aCoder.encode(self.phone, forKey:"phone")
        aCoder.encode(self.email, forKey:"email")
        aCoder.encode(self.otpValidated, forKey:"field_otp_validated")
        aCoder.encode(self.env.rawValue, forKey:"env")
    }
}
