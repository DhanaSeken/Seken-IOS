//
//  OTPViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 09/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK

protocol OTPViewControllerCDelegate: class{
    func pushDashboardVC()
}

class OTPViewController: SekenViewController {

    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    var phoneNumber:String = ""
    var email:String = ""
    var otpStr:String = ""
    var password:String = ""
    var disPlayPhoneNumber:String = ""
    var socialType:String = ""
    weak var delegate: OTPViewControllerCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Verify OTP"
         self.generateOTP()
        self.setBackBarButtonCustom()
        txtOTP1.delegate = self as? UITextFieldDelegate
        txtOTP2.delegate = self as? UITextFieldDelegate
        txtOTP3.delegate = self as? UITextFieldDelegate
        txtOTP4.delegate = self as? UITextFieldDelegate
        txtOTP1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtOTP2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtOTP3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtOTP4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.generateOTP()
         self.lblPhoneNumber.text = self.disPlayPhoneNumber
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    @IBAction func cancelButtonCliked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case txtOTP1:
                txtOTP2.becomeFirstResponder()
            case txtOTP2:
                txtOTP3.becomeFirstResponder()
            case txtOTP3:
                txtOTP4.becomeFirstResponder()
            case txtOTP4:
                txtOTP4.resignFirstResponder()
            default:
                break
            }
        }
    }

    @IBAction func submitButtonTouchupInside(_ sender: Any) {
        
           if let otp1 = self.txtOTP1.text, otp1.characters.count > 0, let otp2 = self.txtOTP2.text, otp2.characters.count > 0, let otp3 = self.txtOTP3.text, otp3.characters.count > 0, let otp4 = self.txtOTP4.text, otp4.characters.count > 0 {
            
               let OTPStr = String(format: "%@%@%@%@",otp1,otp2,otp3,otp4)
               print(OTPStr)
            if self.otpStr == OTPStr {
                 self.showActivityIndicator()
                UserAPI.sharedAPI.performValidateOTP(phoneNumber: self.phoneNumber, email: self.email, OTP: self.otpStr, method: "POST", successHandler: {
                    self.hideActivityIndicator()
                    
                    if self.socialType.characters.count>0 {
                        
                        self.showDashBoard()
                    }else {
                        
                        if self.password.characters.count>0 {
                             self.calSigninCal()
                        }else{
                             self.delegate?.pushDashboardVC()
                        }
                       
                    }
                    
                 
                    
                }, failureHandler: {  errorDescrpition in
                    self.hideActivityIndicator()
                    AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorDescrpition, handler: nil)
                }, env: .dev)
            }else{
                 AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "Please enter valid OTP", handler: nil)
            }
           
            
            
        }
}
    
    func calSigninCal()  {
        self.showActivityIndicator()
        UserAPI.sharedAPI.performLogin(userName: self.email, password: password, method: "POST", successHandler: {
            self.hideActivityIndicator()
            self.showDashBoard()
        }, failureHandler: { errorDescrpition in
            self.hideActivityIndicator()
        }, env: .dev)
    }
    
    @IBAction func resendButtonTouchUpinside(_ sender: Any) {
        
        self.generateOTP()
    }
    
    func showDashBoard()  {
        
        self.dismiss(animated: true) {
            self.delegate?.pushDashboardVC()
        }
       
     
    }
    
    func generateOTP() {
        
        self.showActivityIndicator()
        UserAPI.sharedAPI.performGenerateOTP(phoneNumber: self.phoneNumber, email: self.email, method: "POST", successHandler: { otp in
             self.hideActivityIndicator()
            self.otpStr = otp
            
        }, failureHandler: { errorDescrpition in
             self.hideActivityIndicator()
            AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorDescrpition, handler: nil)
        }, env: .dev)
        
    }
    

}
