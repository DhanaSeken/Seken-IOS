//
//  VerifyOTPViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 10/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK
class VerifyOTPViewController: SekenViewController {
    
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var btnVerify: SekenButton!
    var otpStr:String = ""
    var phoneNumber = ""
    var email = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Verify OTP"
        self.setBackBarButtonCustom()
        
        txtOTP1.delegate = self as? UITextFieldDelegate
        txtOTP2.delegate = self as? UITextFieldDelegate
        txtOTP3.delegate = self as? UITextFieldDelegate
        txtOTP4.delegate = self as? UITextFieldDelegate
        
        
        txtOTP1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtOTP2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtOTP3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtOTP4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    self.lblDescription.text =   String(format: "OTP Sent to %@",self.phoneNumber)
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

    
    
    @IBAction func verifyButtonTouchupInside(_ sender: Any) {
        
        if let otp1 = self.txtOTP1.text, otp1.characters.count > 0, let otp2 = self.txtOTP2.text, otp2.characters.count > 0, let otp3 = self.txtOTP3.text, otp3.characters.count > 0, let otp4 = self.txtOTP4.text, otp4.characters.count > 0 {
            let OTPStr = String(format: "%@%@%@%@",otp1,otp2,otp3,otp4)
            print(OTPStr)
           // if self.otpStr == OTPStr {
                 self.showActivityIndicator()
                UserAPI.sharedAPI.performForgotValidateOTP(phoneNumber: self.phoneNumber, email: self.email, OTP: OTPStr, method: "POST", successHandler: {
                    self.hideActivityIndicator()
                    self.navigateCreatePasswordVC()
                    
                }, failureHandler: { erormessage in
                     AlertViewManager.shared.ShowOkAlert(title: "Error!", message: erormessage, handler: nil)
                    self.hideActivityIndicator()
                }, env: .dev)
                
//          }else{
//                AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "Please enter valid OTP", handler: nil)
//
//            }
        
    }
}
    
    
func navigateCreatePasswordVC() {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let createPasswordVC = storyBoard.instantiateViewController(withIdentifier: "CreatePasswordViewController") as! CreatePasswordViewController
    createPasswordVC.phoneNumber = self.phoneNumber
    createPasswordVC.email = self.email
    self.navigationController?.pushViewController(createPasswordVC, animated: true)
    
    }
    
}
