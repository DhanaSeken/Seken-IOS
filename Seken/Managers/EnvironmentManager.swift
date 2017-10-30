//
//  EnvironmentManager.swift
//  Seken
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
import SekenSDK

class EnvironmentManager {
    private init() {}
    public static let shared = EnvironmentManager()
    public var selectedEnvironment: Environment = .prod
    
    func showEnvironmentChooser() {
        let development = UIAlertAction.init(title: "Development", style: .default, handler: {
            action in
            
            self.selectedEnvironment = .dev
        })
        
        let staging = UIAlertAction.init(title: "Staging", style: .default, handler: {
            action in
            
            self.selectedEnvironment = .staging
        })
        
        let production = UIAlertAction.init(title: "Production", style: .default, handler: {
            action in
            
            self.selectedEnvironment = .prod
        })
        
        AlertViewManager.shared.ShowAlert(title: "", message: "Choose your Environment", actions: [development, staging, production])
    }
}
