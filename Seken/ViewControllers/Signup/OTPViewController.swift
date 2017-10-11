//
//  OTPViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 09/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

class OTPViewController: SekenViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Verify OTP"
        self.setBackBarButtonCustom()
    }
    
    @IBAction func cancelButtonCliked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    

}
