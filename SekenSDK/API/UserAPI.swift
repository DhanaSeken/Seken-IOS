//
//  UserAPI.swift
//  SekenSDK
//
//  Created by Apple on 20/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation

public class UserAPI {
    private init() {}
    
    public static let sharedAPI = UserAPI()
    
    public func performLogin(userName: String, password: String, method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "username": userName,
            "password": password
        ]
        
        SekenAPI.sharedAPI.performRequest(method: "user/login", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let userDetails = response as? Dictionary<String, Any> {
                    let currentUser = User.init(userDetails: userDetails, environment: env)
                    UserManager.shared.save(user: currentUser)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                }
                successHandler?()
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Invalid Username/Password")
                }
                
                break
            }
        })
    }
    
    public func performSignup(mail: String, password: String, fieldPhoneNumber:String,fieldFullName:String,referalCode:String,fieldDeviceType:String,method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "mail": mail,
            "pass":password,
            "field_phone_number":fieldPhoneNumber,
            "field_full_name":fieldFullName,
            "field_device_type":fieldDeviceType,
            "field_referal_code":referalCode,
             ]
        
        SekenAPI.sharedAPI.performRequest(method: "user", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let userDetails = response as? Dictionary<String, Any> {
                    let currentUser = User.init(userDetails: userDetails, environment: env)
                    UserManager.shared.save(user: currentUser)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                }
                successHandler?()
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
   
    
    public func performGenerateOTP(phoneNumber: String, email: String, method: String, successHandler:  ((String) -> ())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "phone_number": phoneNumber,
            "email": email,
        ]
        
        SekenAPI.sharedAPI.performRequest(method: "otp/generate", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                var otpString:String = ""
                if let otpDetails = response as? Dictionary<String, Any> {
                    print(otpDetails)
                    otpString = otpDetails["otp"] as! String
                   }
                successHandler?(otpString)
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    public func performForgotGenerateOTP(phoneNumber: String, email: String, method: String, successHandler:  ((String) -> ())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "phone_number": phoneNumber,
            "email": email,
            ]
        
        SekenAPI.sharedAPI.performRequest(method: "forgot/password", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                var otpString:String = ""
                if let otpDetails = response as? Dictionary<String, Any> {
                    print(otpDetails)
                    otpString = otpDetails["message"] as! String
                }
                successHandler?(otpString)
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
    public func performValidateOTP(phoneNumber: String, email: String,OTP: String, method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "phone_number": phoneNumber,
            "email": email,
            "otp":OTP
        ]
        
        SekenAPI.sharedAPI.performRequest(method: "otp/validate", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                successHandler?()
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
    public func performForgotValidateOTP(phoneNumber: String, email: String,OTP: String, method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "phone_number": phoneNumber,
            "email": email,
            "otp":OTP
        ]
        
        SekenAPI.sharedAPI.performRequest(method: "forgot/validate", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                successHandler?()
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    public func performForgotUpdatePassword(phoneNumber: String, email: String,password: String, method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "phone_number": phoneNumber,
            "email": email,
            "password":password
        ]
        
        SekenAPI.sharedAPI.performRequest(method: "forgot/update", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                successHandler?()
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
    public func performGetUserToken(method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
       
        SekenAPI.sharedAPI.performRequest(method: "user/token", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let tokenDetails = response as? Dictionary<String, Any> {
                    print(tokenDetails)
                    SekenAPI.sharedAPI.sessionToken = tokenDetails["token"] as? String
                }
                successHandler?()
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    public func performLogout(method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "user/logout", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                 UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                successHandler?()
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
    public func performForgotPassword(phoneNumber: String, email: String,method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "forgot/password", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                successHandler?()
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
    public func performSocialLogin(provider: String, identifier: String,method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "provider":provider,
            "identifier":identifier
        ]
        
        SekenAPI.sharedAPI.performRequest(method: "hybridauth/login", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let userDetails = response as? Dictionary<String, Any> {
                    let currentUser = User.init(userDetails: userDetails, environment: env)
                    UserManager.shared.save(user: currentUser)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                }
                successHandler?()
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
    public func performSocialSignup(phoneNumber: String, email: String,name: String,deviceType: String,provider: String,identifier: String,profileURL: String,gender: String,birthday: String,referalCode: String,method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "mail": email,
            "field_phone_number":phoneNumber,
            "field_full_name":name,
            "field_device_type":deviceType,
            "field_referal_code":referalCode,
            "provider":provider,
            "identifier":identifier,
            "profileURL":profileURL,
            "gender":gender
            ]
        SekenAPI.sharedAPI.performRequest(method: "hybridauth/register", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                successHandler?()
                
                break
                
            default:
                if let errorDetails = response as? Dictionary<String, Any> {
                    print(errorDetails)
                    failureHandler?((errorDetails["seken_errors"] as? String)!)
                }else {
                    failureHandler?("Some thing went wrong,Please try again later!")
                }
                break
            }
        })
    }
    
}
