//
//  SekenButton.swift
//  Seken
//
//  Created by Seken InfoSys on 09/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import Foundation
class SekenButton: UIButton {

    let corner_radius : CGFloat =  6.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corner_radius
        self.backgroundColor = UIColor(red: 48/255, green: 115/255, blue: 150/255, alpha: 1.0)
        self.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1.0), for: .normal)
        self.titleLabel!.font =  UIFont(name: "SanFranciscoDisplay-Medium", size:18)
    }

}
