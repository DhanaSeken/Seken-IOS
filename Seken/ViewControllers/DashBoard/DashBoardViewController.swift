//
//  DashBoardViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 26/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK

class DashBoardViewController: SekenViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setBackBarButtonCustom()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(addTapped))
    }

    override func setBackBarButtonCustom()
    {
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: ""), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc override func onClcikBack(){
    }
    
    @objc func addTapped() {
        self.logout()
    }
    
    
    
    
    
    func getToken()  {
        UserAPI.sharedAPI.performGetUserToken(method: "POST", successHandler: {
            self.logout()
            
        }, failureHandler: {errormessage in
            
        }, env: .dev)
    }
    
    
    func logout()  {
        UserAPI.sharedAPI.performLogout(method: "POST", successHandler: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showLoginController() 
        }, failureHandler: { errormessage in
            
        }, env: .dev)
    }

}


