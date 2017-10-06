//
//  User.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

public class User : NSObject, NSCoding {
    private var userName:String
    private var password:String
    private var id: String
    public var token: String
    public var phone: String
    private var email: String
    private var points: String
    
    private var env:Environment
    
    init(userDetails: Dictionary<String,Any>, environment: Environment) {
        let userDict = (userDetails as NSDictionary)
        
        self.userName = userDict.value(forKeyPath: "user.name") as? String ?? ""
        self.password = userDetails["password"] as? String ?? ""
        self.id = userDict.value(forKeyPath: "user.id") as? String ?? ""
        self.token = userDetails["token"] as? String ?? ""
        self.phone = userDict.value(forKeyPath: "user.phone") as? String ?? ""
        self.email = userDict.value(forKeyPath: "user.email") as? String ?? ""
        self.points = userDict.value(forKeyPath: "user.points") as? String ?? ""
        
        self.env = environment
        
        SekenAPI.sharedAPI.env = self.env
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
        self.password = aDecoder.decodeObject(forKey: "password") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.points = aDecoder.decodeObject(forKey: "points") as? String ?? ""
        
        self.env = Environment(rawValue: aDecoder.decodeObject(forKey: "env") as? Int ?? aDecoder.decodeInteger(forKey: "env")) ?? .PROD
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userName, forKey:"userName")
        aCoder.encode(self.password, forKey:"password")
        aCoder.encode(self.id, forKey:"id")
        aCoder.encode(self.token, forKey:"token")
        aCoder.encode(self.phone, forKey:"phone")
        aCoder.encode(self.email, forKey:"email")
        aCoder.encode(self.points, forKey:"points")
        
        aCoder.encode(self.env.rawValue, forKey:"env")
    }
}
