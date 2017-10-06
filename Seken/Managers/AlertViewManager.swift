//
//  AlertViewManager.swift
//  Seken
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
import UIKit

struct AlertControllerInfo {
    var presentingVC : UIViewController
    var alertController : UIAlertController
}

class AlertViewManager {
    
    private init() {}
    public static let shared = AlertViewManager()
    
    private var alertCtrls = [AlertControllerInfo]()
    
    func ShowActions(title: String?, message: String?, actions: [UIAlertAction], view: AnyObject) {
        self.showAlert(title: title, message: message, actions: actions, style: UIAlertControllerStyle.actionSheet, view: view)
    }
    
    func ShowAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        self.showAlert(title: title, message: message, actions: actions, style: UIAlertControllerStyle.alert, view: nil)
    }
    
    func ShowOkAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: handler)
        
        self.showAlert(title: title, message: message, actions: [okAction], style: UIAlertControllerStyle.alert, view: nil)
    }
    
    private func showAlert(title: String?, message: String?, actions: [UIAlertAction], style: UIAlertControllerStyle, view: AnyObject?) {
        
        let alertController = UIAlertController.init(title: title, message: message == "" ? nil : message, preferredStyle: style) as UIAlertController
        
        for action: UIAlertAction in actions {
            alertController .addAction(action)
        }
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window, let presentingViewController = window.rootViewController {
            
            let popOverPresentationVC = alertController.popoverPresentationController
            
            if let popover = popOverPresentationVC {
                if let view = view as? UIBarButtonItem {
                    popover.barButtonItem = view
                }
                else if let view = view as? UIView {
                    popover.sourceView = view;
                    popOverPresentationVC?.sourceRect = view.bounds;
                } else {
                    popOverPresentationVC?.sourceView = presentingViewController.view;
                    popOverPresentationVC?.sourceRect = presentingViewController.view.bounds;
                }
                
                popOverPresentationVC?.permittedArrowDirections = UIPopoverArrowDirection.any;
            }
            
            self.presentAlertController(alertController: alertController, presentingViewController: presentingViewController)
        }
    }
    
    func ShowAlertWithController(alertController : UIAlertController) {
        if let presentingViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            self.presentAlertController(alertController: alertController, presentingViewController: presentingViewController)
        }
    }
    
    func presentAlertController(alertController : UIAlertController, presentingViewController : UIViewController) {
        DispatchQueue.main.async() { () -> Void in
            // Handle modal VC scenarios
            if let presentedModalVC = presentingViewController.presentedViewController {
                presentedModalVC.present(alertController, animated: true, completion: nil)
                self.alertCtrls.append(AlertControllerInfo(presentingVC:presentedModalVC, alertController: alertController))
            }
            else {
                presentingViewController.present(alertController, animated: true, completion: nil)
                self.alertCtrls.append(AlertControllerInfo(presentingVC:presentingViewController, alertController: alertController))
            }
        }
    }
    
    func CancelAllAlerts() {
        for alertCtrl in alertCtrls {
            if alertCtrl.alertController.presentingViewController != nil {
                alertCtrl.presentingVC.dismiss(animated: false, completion: {
                    
                    if let index = self.findAlertController(alertCtrl: alertCtrl.alertController) {
                        self.alertCtrls.remove(at: index)
                    }
                })
            } else {
                self.alertCtrls.remove(at: self.findAlertController(alertCtrl: alertCtrl.alertController)!)
            }
        }
    }
    
    func findAlertController(alertCtrl: UIAlertController) -> Int? {
        for i in 0..<alertCtrls.count {
            if alertCtrls[i].alertController == alertCtrl {
                return i
            }
        }
        return nil
    }
}
