//
//  HotelRoom.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 19/11/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
enum hotelRoomType : Int
{
    case instance
    case nonInstance
    
}
public class HotelRoom:NSObject {
    
     public var propertyID:String
     public var name:String
     public var price:String
     public var image:String
     public var favourite:String
    
    init(hotelRoomDetails: [String: Any]) {
         let hotelRoomDict = (hotelRoomDetails as NSDictionary)
          self.name = hotelRoomDict["name"] as? String ?? ""
          self.propertyID = hotelRoomDict["image"] as? String ?? ""
          self.price = hotelRoomDict["lat"] as? String ?? ""
          self.image = hotelRoomDict["long"] as? String ?? ""
          self.favourite = hotelRoomDict["long"] as? String ?? ""
        
        
    }
    
}
