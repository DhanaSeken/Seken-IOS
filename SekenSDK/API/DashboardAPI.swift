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
}
