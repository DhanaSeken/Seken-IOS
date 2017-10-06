//
//  Image.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation

public class Image {
    public var image: UIImage
    
    private init() {
        image = UIImage()
    }
    
    public init(image: UIImage) {
        self.image = image
    }
    
    func asJPEG() -> Data {
        return UIImageJPEGRepresentation(self.image, 0.8)!
    }
}
