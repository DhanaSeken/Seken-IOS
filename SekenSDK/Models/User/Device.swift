//
//  Device.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation

public class Device {
    private init() {}
    public static let current = Device()
    
    let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    let clientName = UIDevice.current.systemName
    let clientVersion = UIDevice.current.systemVersion
}
