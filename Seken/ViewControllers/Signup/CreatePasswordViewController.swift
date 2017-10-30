//
//  CreatePasswordViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 10/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK

class CreatePasswordViewController: SekenViewController {
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDescrption: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnShow: UIButton!
    
    var phoneNumber = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Create Password"
        self.setBackBarButtonCustom()
    }

    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        
        if let password = self.txtPassword.text, password.characters.count > 0 {
            if self.isPasswordValid(password){
                self.showActivityIndicator()
                UserAPI.sharedAPI.performForgotUpdatePassword(phoneNumber: self.phoneNumber, email: self.email, password: password, method: "POST", successHandler: {
                    self.hideActivityIndicator()
                    let okay = UIAlertAction.init(title: "OK", style: .default, handler: {
                        action in
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    })
                    AlertViewManager.shared.ShowAlert(title: "Sucess", message: "Sucessfully updated your password!", actions: [okay])
                }, failureHandler: { errorMessage in
                    self.hideActivityIndicator()
                    AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorMessage, handler: nil)
                }, env: .dev)
            }else{
                AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "Please enter valid password!", handler: nil)
            }
          
        }else{
             AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "Password should not be empty!", handler: nil)
        }
    }
    
    @IBAction func showButtonCliked(_ sender: Any) {
        let buttonTitle = (sender as AnyObject).title(for: .normal)
        if buttonTitle == "Show" {
            txtPassword.isSecureTextEntry = false;
            self.btnShow.setTitle("Hide", for: .normal);
        }else {
            txtPassword.isSecureTextEntry = true;
            self.btnShow.setTitle("Show", for: .normal);
        }
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
