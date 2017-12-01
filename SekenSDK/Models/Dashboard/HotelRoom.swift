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
     public var lat:String
     public var long:String
     public var adress:String
     public var rating:String
     public var review:String
     public var distance:String
     public var type:String
    
    init(hotelRoomDetails: [String: Any]) {
         let hotelRoomDict = (hotelRoomDetails as NSDictionary)
          self.name = hotelRoomDict["name"] as? String ?? ""
          self.propertyID = hotelRoomDict["property_id"] as? String ?? ""
          self.price = hotelRoomDict["price"] as? String ?? ""
          self.image = hotelRoomDict["image"] as? String ?? ""
          self.favourite = hotelRoomDict["favourite"] as? String ?? ""
         self.lat = hotelRoomDict["lat"] as? String ?? ""
         self.long = hotelRoomDict["lng"] as? String ?? ""
         self.adress = hotelRoomDict["address"] as? String ?? ""
         self.review = hotelRoomDict["reviews"] as? String ?? ""
         self.distance = hotelRoomDict["distance"] as? String ?? ""
         self.rating = hotelRoomDict["rating"] as? String ?? ""
         self.type = hotelRoomDict["type"] as? String ?? ""
        
        
    }
    
}
