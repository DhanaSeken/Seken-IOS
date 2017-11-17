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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var placesContainerView: UIView!
    @IBOutlet weak var topRatedContainerView: UIView!
    @IBOutlet weak var budgetContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setBackBarButtonCustom()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(addTapped))
        self.setupDefaultValues()
      
    }
    
    
    func setupShadow(view:UIView)  {
        self.locationContainerView.layer.masksToBounds = false
        self.locationContainerView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.locationContainerView.layer.shadowRadius = 1
        self.locationContainerView.layer.shadowOpacity = 0.5
    }
    
    func setupDefaultValues() {
        self.setupShadow(view: self.locationContainerView)
        self.setupShadow(view: self.placesContainerView)
        self.setupShadow(view: self.topRatedContainerView)
        self.setupShadow(view: self.budgetContainerView)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 65/255, green: 154/255, blue: 198/255, alpha: 1.0)
          self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: (self.budgetContainerView.frame.origin.y+self.budgetContainerView.frame.size.height))
        self.scrollView.setContentOffset(CGPoint(x:0,y:0), animated: false)
        
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



