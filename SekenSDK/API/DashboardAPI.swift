//
//  DashboardAPI.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 19/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
public class DashboardAPI {
    
    private init() {}
    public static let sharedAPI = DashboardAPI()
    
    public func performGetDashboardData(method: String, successHandler: ((DashBoard)->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "dashboard/index", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let dashboardDetails = response as? Dictionary<String, Any> {
                 let dashboard = DashBoard.init(dashBoradDetails: dashboardDetails)
                     successHandler?(dashboard)
                }
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

    public func performFavoutaiteRoom(ProprtyID: String, status: String, method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "property_id": ProprtyID,
            "status": status
        ]
        
        SekenAPI.sharedAPI.performRequest(method: "property/favourite", type: .post, queryParams: nil, customHeaders: nil, content: details, completionHandler: {
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
    
      public func performGetDashboardTopCities(method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "dashboard/toplocalities", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
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
    public func performGetAminitiesAndHouseRule(method: String, successHandler: (()->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "dashboard/seed", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
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
    public func performGetTopLocalities(method: String, successHandler: ((TopLocalities)->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "dashboard/toplocalities", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let dashboardDetails = response as? Dictionary<String, Any> {
                    let topLocalities = TopLocalities.init(dashBoradDetails: dashboardDetails)
                    successHandler?(topLocalities)
                }
               
                
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
    
    public func performGetAllLocalities(method: String, successHandler: ((AllLocalities)->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "dashboard/alllocalities", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let dashboardDetails = response as? [Dictionary<String, Any>]  {
                    let topLocalities = AllLocalities.init(dashBoradDetails: dashboardDetails)
                    successHandler?(topLocalities)
                }
                
                
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
    public func performGetFilterData(method: String, successHandler: ((SearchResullt)->())?, failureHandler: ((String) -> ())?, env: Environment) {
        
        SekenAPI.sharedAPI.performRequest(method: "property/search", type: .post, queryParams: nil, customHeaders: nil, content: nil, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let searchResultDetails = response as? Dictionary<String, Any> {
                    let serachDetails = SearchResullt.init(searchDetails: searchResultDetails)
                    successHandler?(serachDetails)
                    
                   }
                
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
    
    public func performSearchFilterData(city: String, lat: String,lon: String,checkInDate: String,checkoutDate: String,numberofGuest: String,propertyType: [String],bookingType: String,priceFrom: String,priceTo: String,rooms: String,beds: String,amenities: [String],houseRules: [String],cancelPolicy: [String], method: String, successHandler: ((SearchResullt)->())?, failureHandler: ((String) -> ())?, env: Environment) {
        let details = [
            "city": city,
            "lat": lat,
            "lng":lon,
            "check_in": checkInDate,
            "check_out": checkoutDate,
            "no_of_guests":numberofGuest,
            "property_type": propertyType,
            "booking_type": bookingType,
            "price_from":priceFrom,
            "price_to":priceTo,
             "rooms":rooms,
             "beds":beds,
             "amenities":amenities,
             "house_rules":houseRules,
             "cancel_policy":cancelPolicy
            ] as [String : Any]
        
        SekenAPI.sharedAPI.performRequest(method: "property/search", type: .post, queryParams: nil, customHeaders: nil, content: details as? Dictionary<String, String>, completionHandler: {
            statusCode, response, data, error in
            
            switch statusCode {
            case 200 :
                if let searchResultDetails = response as? Dictionary<String, Any> {
                    let serachDetails = SearchResullt.init(searchDetails: searchResultDetails)
                    successHandler?(serachDetails)
                    
                }
                
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
