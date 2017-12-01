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
    
    var locationViewController: LocationViewController!
    var placesViewController: PlacesViewController!
    var topRatedViewController: TopRatedViewController!
    var budgetRatedViewController: BudgetRoomController!
    let serachContainerView = "SerachView"
    let placeContainerView = "PlaceView"
    let TopContainerView = "TopView"
    let BudgetContainerView = "BudgetView"
    var dashboardData:DashBoard?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setBackBarButtonCustom()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(addTapped))
        self.setupDefaultValues()
       
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.locationViewController?.btnSearch.addTarget(self, action: #selector(searchButtonCliked), for: .touchUpInside)
         self.placesViewController?.btnViewAll.addTarget(self, action: #selector(viewAllButtonCliked), for: .touchUpInside)
        self.topRatedViewController?.btnViewAll.addTarget(self, action: #selector(topRatedViewAllButtonCliked), for: .touchUpInside)
        self.budgetRatedViewController?.btnViewAll.addTarget(self, action: #selector(budgetViewAllButtonCliked), for: .touchUpInside)
        
        
         self.calDashBoardCal()
    }
    
    func calDashBoardCal()  {
        
        self.showActivityIndicator()
        DashboardAPI.sharedAPI.performGetDashboardData(method: "POST", successHandler: { dashboard in
             self.hideActivityIndicator()
            self.dashboardData = dashboard
            self.reloadScreenUisngData(dashBoardData: dashboard)
            
        }, failureHandler: { errorMessage in
              self.hideActivityIndicator()
            if errorMessage == "User is not logged in."{
                let okay = UIAlertAction.init(title: "OK", style: .default, handler: {
                    action in
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.showLoginController()
                    
                })
                AlertViewManager.shared.ShowAlert(title: "Opps", message: "Your are not logged in User!", actions: [okay])
            }else{
                AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorMessage, handler: nil)
            }
        }, env: .dev)
    }
    
    func reloadScreenUisngData(dashBoardData:DashBoard) {
        
          self.placesViewController.refreshCollectionView(localities: dashBoardData.localities)
          self.topRatedViewController.refreshCollectionView(hotelRooms: dashBoardData.instanceRooms)
          self.budgetRatedViewController.refreshCollectionView(hotelRooms: dashBoardData.nonInstanceRooms)
             self.placesViewController.lblTitle.text = self.dashboardData?.keysList[0].uppercased()
             self.topRatedViewController.lblTitle.text = self.dashboardData?.keysList[1].uppercased()
              self.budgetRatedViewController.lblTitle.text = self.dashboardData?.keysList[2].uppercased()

       
    }
    
    
    func setupShadow(view:UIView)  {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.5
    }
    
    func setupDefaultValues() {
        self.setupShadow(view: self.locationContainerView)
        self.setupShadow(view: self.placesContainerView)
        self.setupShadow(view: self.topRatedContainerView)
        self.setupShadow(view: self.budgetContainerView)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 65/255, green: 154/255, blue: 198/255, alpha: 1.0)
          self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: (self.budgetContainerView.frame.origin.y+self.budgetContainerView.frame.size.height+60))
       // self.scrollView.setContentOffset(CGPoint(x:0,y:-50), animated: false)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == serachContainerView {
            if let vc = segue.destination as? LocationViewController,
                segue.identifier == serachContainerView {
                self.locationViewController = vc
            }
        }
        if segue.identifier == placeContainerView {
            if let vc = segue.destination as? PlacesViewController,
                segue.identifier == placeContainerView {
                self.placesViewController = vc
            }
        }
        if segue.identifier == TopContainerView {
            if let vc = segue.destination as? TopRatedViewController,
                segue.identifier == TopContainerView {
                self.topRatedViewController = vc
            }
        }
        if segue.identifier == BudgetContainerView {
            if let vc = segue.destination as? BudgetRoomController,
                segue.identifier == BudgetContainerView {
                self.budgetRatedViewController = vc
            }
        }
    }
    
    @objc func searchButtonCliked() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchLocationViewController") as! SearchLocationViewController
        newViewController.recentSearches = (self.dashboardData?.localities)!
        newViewController.topCities = (self.dashboardData?.localities)!
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    @objc func viewAllButtonCliked() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LocationViewAllVC") as! LocationViewAllVC
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
   @objc func  topRatedViewAllButtonCliked() {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
    let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC
      newViewController.bookingType = "1"
    self.navigationController?.pushViewController(newViewController, animated: true)
    
    }
    
    @objc func  budgetViewAllButtonCliked() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }

}



