//
//  ForgotPasswordController.swift
//  Seken
//
//  Created by Seken InfoSys on 10/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK

class ForgotPasswordController: SekenViewController,ContryCodeModalVCDelegate,UITextFieldDelegate {
    func sendCountryImag(img: UIImage, countryCode: String) {
        self.btnEmailPass.setBackgroundImage(img, for: .normal)
        self.countryCode = countryCode
    }
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnEmailPass: UIButton!
    @IBOutlet weak var lblDescption: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnOTP: SekenButton!
    @IBOutlet weak var emailPhoneWidthConstarins: NSLayoutConstraint!
    var emailLogin = false
    var countryCode:String = ""
    var email:String = ""
    var phoneNumber:String = ""
    var otpStr:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Forgot Password"
        self.txtPhoneNumber.delegate = self;
        self.setBackBarButtonCustom()
        self.countryCode = "966"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    @IBAction func otpButtonTouchupInside(_ sender: Any) {
        
        if let userName = self.txtPhoneNumber.text, userName.count > 0 {
            
            if self.isValidEmail(testStr: userName) {
                email = userName
                phoneNumber = ""
                self.emailLogin = true
            }else{
                if (userName.isStringAnInt()) {
                    email = ""
                    phoneNumber = String(format: "%@%@",self.countryCode,userName)
                      self.emailLogin = false
                }else{
                    AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "Please enter valid phone number", handler: nil)
                    return
                }
            }
            self.forgotOTPCal()
            
       } else{
            AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "email/phonenumber  should not be empty", handler: nil)
            
        }
    }
    
    func forgotOTPCal() {
        
        UserAPI.sharedAPI.performForgotGenerateOTP(phoneNumber: phoneNumber, email: email, method: "POST", successHandler: { otpString in
            if(self.emailLogin) {
                
                let okay = UIAlertAction.init(title: "OK", style: .default, handler: {
                    action in
                    self.navigateVerifyOTP()
                    
                })
                AlertViewManager.shared.ShowAlert(title: "Sucess", message: "OTP Sended Your register mail ID", actions: [okay])
            }else{
                self.otpStr = otpString
                self.navigateVerifyOTP()
            }
            
            
        }, failureHandler: { errorMessage in
             AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorMessage, handler: nil)
        }, env: .dev)
        
    }
    
    @IBAction func resendButtonTouchUpinside(_ sender: Any) {
        
        self.forgotOTPCal()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ContryCodeModalVC"{
            let nextScene = segue.destination as? ContryCodeModalVC
            nextScene?.delegate = self
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (newString as NSString?) != nil {
            
            if newString.count>0 {
                
                if (newString.isStringAnInt()) {
                    var dict = super.getcountryCode()
                    countryCode = dict["dial_code"] as! String
                    let btnImage = dict["flag"] as? UIImage
                    self.btnEmailPass.isUserInteractionEnabled = true
                    self.btnEmailPass.setBackgroundImage(btnImage, for: .normal)
                    self.emailPhoneWidthConstarins.constant = 45
                    self.view.layoutIfNeeded()
                    
                }else {
                    let btnImage = UIImage(named: "Mail_Icon")
                    self.btnEmailPass.isUserInteractionEnabled = false
                    self.btnEmailPass.setBackgroundImage(btnImage, for: .normal)
                    self.emailPhoneWidthConstarins.constant = 30
                    self.view.layoutIfNeeded()
                }
            }else{
                let btnImage = UIImage(named: "Emailorphonenumber")
                self.btnEmailPass.setBackgroundImage(btnImage, for: .normal)
                self.btnEmailPass.isUserInteractionEnabled = false
                self.emailPhoneWidthConstarins.constant = 30
                self.view.layoutIfNeeded()
                
            }
            
            
        }
        
        return true
    }
    
    func navigateVerifyOTP() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let verifyOTP = storyBoard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
        verifyOTP.phoneNumber = self.phoneNumber
        verifyOTP.email = self.email
        verifyOTP.otpStr = self.otpStr
        self.navigationController?.pushViewController(verifyOTP, animated: true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
