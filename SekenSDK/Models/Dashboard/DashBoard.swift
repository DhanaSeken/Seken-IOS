//
//  DashBoard.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 19/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation

public class DashBoard:NSObject {
    
    public var localities:[Locality] = []
    public var instanceRooms: [HotelRoom] = []
    public var nonInstanceRooms: [HotelRoom] = []
     public var keysList = [String]()
    
    init(dashBoradDetails: [String: Any]) {
        
         let dashBoradDict = (dashBoradDetails as NSDictionary)
        keysList = dashBoradDict.allKeys as! [String]
         let templocalities = dashBoradDict["localities"] as? [[String:String]]
        for localityDict in templocalities! {
            let localityDict = Locality.init(localityDetails: localityDict)
            self.localities.append(localityDict)
        }
        
        let tempInstants = dashBoradDict["instant"] as? [[String:Any]]
        for instantDict in tempInstants! {
            let hotelRoomDict = HotelRoom.init(hotelRoomDetails: instantDict)
            self.instanceRooms.append(hotelRoomDict)
        }
        
        let tempNonInstants = dashBoradDict["regular"] as? [[String:Any]]
        for nonInstantDict in tempNonInstants! {
            let hotelRoomDict = HotelRoom.init(hotelRoomDetails: nonInstantDict)
            self.nonInstanceRooms.append(hotelRoomDict)
        }
        
    }
    
}
