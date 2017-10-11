//
//  LoginViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

class LoginViewController: SekenViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: SekenButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFaceBook: UIButton!
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    // Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Login"
        self.setBackBarButtonCustom()
    }
    
    
    
    //Button Handler
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        var alertString = ""
        
        if self.txtUserName.text?.count==0 {
            alertString = "Username should not empty"
        }else if self.txtPassword.text?.count==0 {
            alertString = "Password should not empty"
        }
        
        if alertString == "" {
            
        }else{
            AlertViewManager.shared.ShowOkAlert(title: "Error!", message: alertString, handler: nil)
        }
        
        
        
    }
    
    
    @IBAction func showButtonClicked(_ sender: Any) {
        let buttonTitle = (sender as AnyObject).title(for: .normal)
        if buttonTitle == "Show" {
            txtPassword.isSecureTextEntry = false;
            self.btnShow.setTitle("Hide", for: .normal);
        }else {
            txtPassword.isSecureTextEntry = true;
            self.btnShow.setTitle("Show", for: .normal);
        }
        
    }
    
    
    //Private Methods
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[a-z0-9!#$%&'*+/=?^&#95;`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^&#95;`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
}

