//
//  Locality.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 19/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation

public class Locality : NSObject {
    
    public var name:String
    public var imagURL: String
    public var lat: String
    public var long: String
    public var localityID:String
    
    init(localityDetails: [String: Any]) {
        let localityDict = (localityDetails as NSDictionary)
        self.name = localityDict["name"] as? String ?? ""
        self.imagURL = localityDict["image"] as? String ?? ""
        self.lat = localityDict["lat"] as? String ?? ""
         self.long = localityDict["long"] as? String ?? ""
        self.localityID = localityDict["id"] as? String ?? ""
 }
   
}
