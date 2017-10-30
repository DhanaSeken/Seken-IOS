//
//  UserManager.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 24/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
public class UserManager {
    private init() {}
    public static let shared = UserManager()
    
    public var currentUser: User? {
        get {
            return self.getUser()
        }
    }
    
    func save(user: User) {
        let data  = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(data, forKey:"CurrentUser" )
    }
    
    private func getUser() -> User? {
        guard let data = UserDefaults.standard.object(forKey: "CurrentUser") as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? User
    }
    
    public func isUserLoggedIn() -> Bool {
        var userLoggedIn = false
        if let userLoggedInState = UserDefaults.standard.value(forKey: "isUserLoggedIn") as? Bool {
            userLoggedIn = userLoggedInState
        }
        
        return userLoggedIn
    }
}
