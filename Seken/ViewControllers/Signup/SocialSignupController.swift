//
//  SocialSignupController.swift
//  Seken
//
//  Created by Seken InfoSys on 28/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK

class SocialSignupController: SekenViewController,ContryCodeModalVCDelegate,OTPViewControllerCDelegate {
    
    func pushDashboardVC() {
        self.calSocialSignIn()
    }
    
    
    func sendCountryImag(img: UIImage, countryCode: String) {
        self.countryCode = countryCode
        self.btnCountryCode.setBackgroundImage(img, for: .normal)
    }
    
    var phoneNumber:String = ""
    var email:String = ""
    var otpStr:String = ""
    var identifier:String = ""
    var provider:String = ""
    var gender:String = ""
    var profilePic:String = ""
    var dob:String = ""
    var name:String = ""
    var countryCode:String = ""
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var txtReferralcode: UITextField!
    @IBOutlet weak var btnSignUp: SekenButton!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    
    
    // MARK:Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackBarButtonCustom()
        self.setupDefaultValues()
         countryCode = "966"
        // Do any additional setup after loading the view.
    }
    //MARK Private Methods
    func setupDefaultValues() {
        self.txtName.text = self.name
        self.txtEmail.text = self.email
        self.txtPhoneNumber.text = self.phoneNumber
         self.txtPhoneNumber.isUserInteractionEnabled = true
         self.txtEmail.isUserInteractionEnabled = true
        self.txtName.isUserInteractionEnabled = true
        self.txtReferralcode.isUserInteractionEnabled = true
        if self.phoneNumber.characters.count>0 {
            self.txtPhoneNumber.isUserInteractionEnabled = false
        }
        if self.email.characters.count>0 {
            self.txtEmail.isUserInteractionEnabled = false
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ContryCodeModalVC"{
            let nextScene = segue.destination as? ContryCodeModalVC
            nextScene?.delegate = self
        }
        
    }
    func getReferalCode() -> String {
        if let text = txtReferralcode.text, text.characters.count > 0 {
            return text
        } else {
            return ""
        }
    }
    func PresentOTPModal() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let otpViewController = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        otpViewController.phoneNumber = String(format: "%@%@",self.countryCode,self.txtPhoneNumber.text!)
        otpViewController.email = self.txtEmail.text!
        otpViewController.password = ""
        otpViewController.socialType =  self.provider
        otpViewController.delegate = self;
        self.present(otpViewController, animated:true, completion:nil)
    }
    
    func showDashBoard() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showDashBoard() 
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Dashboard", bundle:nil)
//        let dashboardVC = storyBoard.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
//        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
    
    func calSocialSignIn()  {
        self.showActivityIndicator()
        UserAPI.sharedAPI.performSocialLogin(provider: self.provider, identifier: self.identifier, method: "POST", successHandler: {
             self.hideActivityIndicator()
            self.showDashBoard()
        }, failureHandler: { errorMessage in
            self.hideActivityIndicator()
            AlertViewManager.shared.ShowOkAlert(title: "Error", message: errorMessage, handler: nil)
        }, env: .dev)
        
    }
    // MARK ButtonHandler
    @IBAction func signupButtonClicked(_ sender: Any) {
        
        if let userName = self.txtName.text, userName.characters.count > 0, let email = self.txtEmail.text, email.characters.count > 0,let phonenumber = self.txtPhoneNumber.text, phonenumber.characters.count > 0{
            self.showActivityIndicator()
            UserAPI.sharedAPI.performSocialSignup(phoneNumber: phonenumber, email: email, name: name, deviceType: "iOS", provider: self.provider, identifier: self.identifier, profileURL: "", gender: "", birthday: "", referalCode: self.getReferalCode(), method: "POST", successHandler: {
                self.hideActivityIndicator()
                self.PresentOTPModal()
            }, failureHandler: { errorMessage in
                 self.hideActivityIndicator()
                  AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorMessage, handler: nil)
            }, env: .dev)
          }else {
            AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "username,email,phonenumber and password should not be empty", handler: nil)
        }
        
    }
   
    
}
