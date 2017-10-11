//
//  SekenViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
import UIKit

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

class SekenViewController: UIViewController {

    private var spinner: UIActivityIndicatorView?
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - Activity Indicator
    
    func showActivityIndicator() {
        enableInteraction(enable: false)
    }
    
    func hideActivityIndicator() {
        enableInteraction(enable: true)
    }
    
    // MARK: - Methods
    
    private func enableInteraction(enable : Bool) {
        
        if spinner == nil {
            spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
            spinner?.activityIndicatorViewStyle = .gray
            self.spinner?.center = CGPoint(x:UIScreen.main.bounds.size.width / 2, y:UIScreen.main.bounds.size.height / 2)
            self.view.addSubview(self.spinner!)
            self.spinner?.hidesWhenStopped = true
        }
        
        self.view.isUserInteractionEnabled = enable
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
        
        if (enable) {
            self.spinner?.stopAnimating()
        } else {
            self.spinner?.startAnimating()
        }
    }
    
    
    func setBackBarButtonCustom()
    {
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backBtn"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

}

@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            navigationBar.barTintColor = uiColor
        }
        get {
            guard let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }
}