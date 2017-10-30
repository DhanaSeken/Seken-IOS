//
//  StringUtils.swift
//  Seken
//
//  Created by Seken InfoSys on 18/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation



extension String {
    
    func isStringAnInt() -> Bool {
        
        if let _ = Int(self) {
            return true
        }
        return false
    }

}
