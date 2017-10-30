//
//  LocationManager.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 24/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    public static let sharedLocation = LocationManager()
    private var locManager = CLLocationManager()
    
    private init() {
        locManager.requestWhenInUseAuthorization()
    }
    
    private func getCurrentLocation() -> CLLocation {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            return locManager.location!
        }
        
        return CLLocation.init()
    }
    
    func getLatitude() -> Double {
        return getCurrentLocation().coordinate.latitude
    }
    
    func getLongitude() -> Double {
        return getCurrentLocation().coordinate.longitude
    }
}
