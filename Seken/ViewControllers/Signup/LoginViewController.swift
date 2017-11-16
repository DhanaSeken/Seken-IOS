//
//  LoginViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import FBSDKShareKit
import MICountryPicker
import SekenSDK

class LoginViewController: SekenViewController,GIDSignInUIDelegate,GIDSignInDelegate,ContryCodeModalVCDelegate,UITextFieldDelegate,OTPViewControllerCDelegate {
    
    func sendCountryImag(img:UIImage,countryCode:String) {
    
        self.btnEmailPass.setImage(img, for: .normal)
        self.countryCode = countryCode
        
    }
    
    
    
    @IBOutlet weak var btnEmailPass: UIButton!
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
    var countryCode:String = ""
    
    
    // Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Login"
        self.setBackBarButtonCustom()
        self.btnEmailPass.isUserInteractionEnabled = false
        self.txtUserName.delegate = self
        self.txtPassword.delegate = self
        countryCode = "966"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    
    
    
    //Button Handler
    @IBAction func loginButtonClicked(_ sender: Any) {
        if let userName = self.txtUserName.text, userName.characters.count > 0, let password = self.txtPassword.text, password.characters.count > 0 {
            
            if self.isValidEmail(testStr: userName) {
                 self.showActivityIndicator()
                UserAPI.sharedAPI.performLogin(userName: userName, password: password, method: "POST", successHandler: {
                    self.hideActivityIndicator()
                    self.navigateNextScreen()
                }, failureHandler: {  errorDescrpition in
                    self.hideActivityIndicator()
                    AlertViewManager.shared.ShowOkAlert(title: "Failure", message: errorDescrpition, handler: nil)
                }, env: .dev)
            }else{
                 self.showActivityIndicator()
                UserAPI.sharedAPI.performLogin(userName: String(format: "%@%@",self.countryCode,userName), password: password, method: "POST", successHandler: {
                    self.hideActivityIndicator()
                    self.navigateNextScreen()
                }, failureHandler: {  errorDescrpition in
                    self.hideActivityIndicator()
                    AlertViewManager.shared.ShowOkAlert(title: "Failure", message: errorDescrpition, handler: nil)
                }, env: .dev)
            }
           
           
        } else{
            AlertViewManager.shared.ShowOkAlert(title: "Error!", message: "username and password should not be empty", handler: nil)
        }
    }
    
    func navigateNextScreen ()  {
        
        if UserManager.shared.currentUser?.otpValidated == "yes" {
             self.pushDashboardVC()
        }else{
           self.PresentOTPModal()
        }
    }
    
    func pushDashboardVC()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showDashBoard()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Dashboard", bundle:nil)
//        let dashboardVC = storyBoard.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
//        self.navigationController?.pushViewController(dashboardVC, animated: true)
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func PresentOTPModal() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let otpViewController = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        otpViewController.phoneNumber = (UserManager.shared.currentUser?.phone)!
        otpViewController.email = (UserManager.shared.currentUser?.email)!
        otpViewController.password = self.txtPassword.text!
        otpViewController.disPlayPhoneNumber = String(format: "+%@-%@",self.countryCode,self.txtUserName.text!)
        otpViewController.delegate = self;
        self.present(otpViewController, animated:true, completion:nil)
        
        
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
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func faceButtonCliked(_ sender: Any) {
        self.showActivityIndicator()
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile,.email,.userFriends ], viewController: self) { loginResult in
            self.hideActivityIndicator()
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                // self.showActivityIndicator()
                print (grantedPermissions)
                print (declinedPermissions)
                print (accessToken)
               // self.calFaceBookLoginService(faceBookId: accessToken.appId, accessToken: accessToken.authenticationToken)
               
            }
        }
    }
    
    @IBAction func googleButtonCliked(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self as GIDSignInDelegate
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().uiDelegate = self as GIDSignInUIDelegate
        GIDSignIn.sharedInstance().signIn()
    }
    
    func getFaceBookUserDetails()  {
        
        self.showActivityIndicator()
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            self.hideActivityIndicator()
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                print(data)
                
            }
        })
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        //print("Sign in presented")
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
        // print("Sign in dismissed")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (user != nil) {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("Welcome: ,\(String(describing: userId)), \(String(describing: idToken)), \(String(describing: fullName)), \(String(describing: givenName)), \(String(describing: familyName)), \(String(describing: email))")
        }
        
      
       // calGoogleLoginService(googleId: userId!, accessToken: idToken!)
    }
    
    @IBAction func emailPassButtonClicked(_ sender: Any) {
        
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
        
        if newString.characters.count>0 {
            
            if (newString.isStringAnInt()) {
                var dict = super.getcountryCode()
                countryCode = dict["dial_code"] as! String
                let btnImage = dict["flag"] as? UIImage
                self.btnEmailPass.isUserInteractionEnabled = true
                self.btnEmailPass.setBackgroundImage(btnImage, for: .normal)
               
            }else {
                let btnImage = UIImage(named: "Mail_Icon")
                self.btnEmailPass.isUserInteractionEnabled = false
                self.btnEmailPass.setBackgroundImage(btnImage, for: .normal)
            }
        }else{
            let btnImage = UIImage(named: "Emailorphonenumber")
            self.btnEmailPass.setBackgroundImage(btnImage, for: .normal)
            self.btnEmailPass.isUserInteractionEnabled = false
            
        }
        

        }

        return true
  }
    
    
    
}

