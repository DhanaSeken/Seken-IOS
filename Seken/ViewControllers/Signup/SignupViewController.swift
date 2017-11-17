//
//  SignupViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import MICountryPicker
import SekenSDK


class SignupViewController: SekenViewController,ContryCodeModalVCDelegate,OTPViewControllerCDelegate {
    
   func sendCountryImag(img:UIImage,countryCode:String) {
        self.countryCode.setBackgroundImage(img, for: .normal)
        self.countryCodeStr = countryCode
    }
    
    func pushDashboardVC()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showDashBoard()

    }
    
    
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtReferralCode: UITextField!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var btnSignUp: SekenButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var lblAlready: UILabel!
    @IBOutlet weak var lblTerams: UILabel!
    @IBOutlet weak var btnTrerms: UIButton!
    @IBOutlet weak var countryCode: NiceButton!
    var countryCodeStr:String = ""
    
    var isrequireViewmove:Bool = false
    var movedValue:NSInteger = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.title = "Signup"
         self.setBackBarButtonCustom()
         txtPassword.isSecureTextEntry = true
        self.countryCodeStr = "966"
        self.txtPhoneNumber.textAlignment = .left
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
       
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        isrequireViewmove = true;
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
         isrequireViewmove = false;
        UIView.animate(withDuration: 1, animations: {
            self.view.frame.origin.y = 0
        }, completion: nil)
        self.movedValue = 0;
    }
 @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    
        if (isrequireViewmove && self.movedValue<=160){
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                    print("Swiped right")
                    break
                case UISwipeGestureRecognizerDirection.down:do {
                    if(self.movedValue >= 40) {
                        UIView.animate(withDuration: 1, animations: {
                            self.view.frame.origin.y += 40
                            self.movedValue = self.movedValue-40
                        }, completion: nil)
                    }
                   
                    print("Swiped down")
                }
                    break
                case UISwipeGestureRecognizerDirection.left:
                    print("Swiped left")
                    break
                case UISwipeGestureRecognizerDirection.up:do {
                    
                        UIView.animate(withDuration: 1, animations: {
                            self.view.frame.origin.y -= 40
                            self.movedValue = self.movedValue+40
                        }, completion: nil)
                        print("Swiped down")
                   
                   
                }
                    break
                default:
                    break
                }
            }
        }
 
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        var dict = super.getcountryCode()
        self.countryCodeStr = dict["dial_code"] as! String
        let btnImage = dict["flag"] as? UIImage
        self.countryCode.setBackgroundImage(btnImage, for: .normal)
        
        
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
    
    @IBAction func signupButtonCliked(_ sender: Any) {
        
          if let userName = self.txtFullName.text, userName.characters.count > 0, let email = self.txtEmail.text, email.characters.count > 0,var phonenumber = self.txtPhoneNumber.text, phonenumber.characters.count > 0,let password = self.txtPassword.text, password.characters.count > 0 {
            
                if (self.countryCodeStr == "966") {
                    if phonenumber.characters.count == 10 {
                         phonenumber =  String(phonenumber.dropFirst())
                    }
                   
                }
                
                if((((self.countryCodeStr == "966" && phonenumber.characters.count == 9) || (self.countryCodeStr == "91" && phonenumber.characters.count == 10))) && self.isValidEmail(testStr: email)) {
                    self.showActivityIndicator()
                    UserAPI.sharedAPI.performSignup(mail: email, password: password, fieldPhoneNumber: String(format: "%@%@",self.countryCodeStr,phonenumber), fieldFullName: userName, referalCode: self.getReferalCode(), fieldDeviceType: "ios", method: "POST", successHandler: {
                        self.hideActivityIndicator()
                        self.PresentOTPModal()
                        
                    }, failureHandler: { errorDescrpition in
                        self.hideActivityIndicator()
                        AlertViewManager.shared.ShowOkAlert(title: "Error!", message: errorDescrpition, handler: nil)
                    }, env: .dev)
                }else{
                    if !self.isValidEmail(testStr: email){
                         AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "Please enter valid email id", handler: nil)
                    }else{
                          AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "Please enter valid phone number", handler: nil)
                    }
                        
                    
                }
                
             
            }else {
                 AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "phone number should be 10 numbers", handler: nil)
            }
           
            
            
        
        
    }
    
    func PresentOTPModal() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let otpViewController = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        otpViewController.phoneNumber = String(format: "%@%@",self.countryCodeStr,self.txtPhoneNumber.text!)
        otpViewController.email = self.txtEmail.text!
        otpViewController.password = self.txtPassword.text!
        otpViewController.disPlayPhoneNumber = String(format: "+%@-%@",self.countryCodeStr,self.txtPhoneNumber.text!)
        otpViewController.delegate = self;
        self.present(otpViewController, animated:true, completion:nil)
        
        
    }
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validate(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    func getReferalCode() -> String {
        if let text = txtReferralCode.text, text.characters.count > 0 {
            return text
        } else {
            return ""
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ContryCodeModalVC"{
            let nextScene = segue.destination as? ContryCodeModalVC
            nextScene?.delegate = self
        }
        
    }
    
    @IBAction override func backbuttonClicked(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}

