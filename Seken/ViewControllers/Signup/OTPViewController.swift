//
//  OTPViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 09/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import SekenSDK

let kMaxRadius: CGFloat = 200
let kMaxDuration: TimeInterval = 10


protocol OTPViewControllerCDelegate: class{
    func pushDashboardVC()
}

class OTPViewController: SekenViewController {

    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var sourceView: UIImageView!
    @IBOutlet weak var btnSubmit: SekenButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblmessage: UILabel!
    
    var phoneNumber:String = ""
    var email:String = ""
    var otpStr:String = ""
    var password:String = ""
    var disPlayPhoneNumber:String = ""
    var socialType:String = ""
    weak var delegate: OTPViewControllerCDelegate?
    var pulsulator: Pulsator!
    var timer : Timer!
    var second = 0
    var message:String = "We will send an confirmation code to your mobile number in 60 Seconds"
    
    
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
        self.initPulseView()
        self.generateOTP()
         self.lblPhoneNumber.text = self.disPlayPhoneNumber
       
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        self.pulsulator.position = sourceView.layer.position
        self.lblmessage.text = self.message;
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
        
           if let otp1 = self.txtOTP1.text, otp1.count > 0, let otp2 = self.txtOTP2.text, otp2.count > 0, let otp3 = self.txtOTP3.text, otp3.count > 0, let otp4 = self.txtOTP4.text, otp4.count > 0 {
            
               let OTPStr = String(format: "%@%@%@%@",otp1,otp2,otp3,otp4)
               print(OTPStr)
           // if self.otpStr == OTPStr {
                 self.showActivityIndicator()
                UserAPI.sharedAPI.performValidateOTP(phoneNumber: self.phoneNumber, email: self.email, OTP: self.otpStr, method: "POST", successHandler: {
                    self.hideActivityIndicator()
                    
                    if self.socialType.count>0 {
                        
                        self.showDashBoard()
                    }else {
                        
                        if self.password.count>0 {
                             self.calSigninCal()
                        }else{
                             self.delegate?.pushDashboardVC()
                        }
                       
                    }
                    
                 
                    
                }, failureHandler: {  errorDescrpition in
                    self.hideActivityIndicator()
                    AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorDescrpition, handler: nil)
                }, env: .dev)
   

            
        }
}
    
    func initPulseView(){
         self.pulsulator = Pulsator()
        sourceView.layer.superlayer?.insertSublayer(self.pulsulator, below: sourceView.layer)
        self.strt()
      
        
    }
    
    func strt()  {
        self.btnSubmit.isUserInteractionEnabled = false
         self.btnResend.isUserInteractionEnabled = false
        self.pulsulator.start()
        self.pulsulator.radius = 0.7 * kMaxRadius
        self.pulsulator.numPulse = 3
        self.pulsulator.radius = 150
         self.pulsulator.backgroundColor = UIColor(red: 0/255, green: 155/255, blue: 203/255, alpha: 1).cgColor
       
        timer = Timer();
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.calculateSeconds), userInfo: nil, repeats: true)
    }
    @objc func calculateSeconds() {
        
        if second<=30 {
        second += 1
        }else{
            second = 0
            timer.invalidate()
            self.pulsulator.stop()
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
         self.strt()
        UserAPI.sharedAPI.performGenerateOTP(phoneNumber: self.phoneNumber, email: self.email, method: "POST", successHandler: { otp in
             self.hideActivityIndicator()
            self.otpStr = otp
            self.second = 0
            self.timer.invalidate()
            self.pulsulator.stop()
            self.btnSubmit.isUserInteractionEnabled = true
            self.btnResend.isUserInteractionEnabled = true
            
            
        }, failureHandler: { errorDescrpition in
             self.hideActivityIndicator()
            self.second = 0
            self.timer.invalidate()
            self.pulsulator.stop()
            self.btnSubmit.isUserInteractionEnabled = true
            self.btnResend.isUserInteractionEnabled = true
            AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorDescrpition, handler: nil)
        }, env: .dev)
        
    }
    

}
