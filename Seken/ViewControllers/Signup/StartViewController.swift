//
//  StartViewController.swift
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
import SekenSDK

class StartViewController: SekenViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    @IBOutlet weak var imgHeaderView: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblsubHeader: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblDescription: UILabel!
    
    var socialSignupType:String = ""
    var identifier:String = ""
    var phoneNumber:String = ""
    var email:String = ""
    var name:String = ""
    var googleUser: GIDGoogleUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.getToken()

        // Do any additional setup after loading the view.
    }
    
    
    func getToken()  {
        UserAPI.sharedAPI.performGetUserToken(method: "POST", successHandler: {
            self.logout()
            
        }, failureHandler: {errormessage in
            
        }, env: .dev)
    }
    
    
    func logout()  {
        UserAPI.sharedAPI.performLogout(method: "POST", successHandler: {
            
        }, failureHandler: { errormessage in
            
        }, env: .dev)
    }
    
    func getFaceBookUserDetails()  {
        
        self.showActivityIndicator()
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            self.hideActivityIndicator()
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                guard let result = result as? NSDictionary, let email = result["email"] as? String,let user_name = result["name"] as? String
                    else {
                        return
                      }
                self.phoneNumber = ""
                self.email = email
                self.name = user_name
                self.pushSocialSingupVC()
                
            }
        })
    }

    @IBAction func faceBookButtonClicked(_ sender: Any) {
        
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
                self.hideActivityIndicator()
                print (grantedPermissions)
                print (declinedPermissions)
                print (accessToken)
                // self.calFaceBookLoginService(faceBookId: accessToken.appId, accessToken: accessToken.authenticationToken)
                self.socialSignupType = "FaceBook"
                self.identifier = accessToken.userId!
                self.calSocialSingin(type: "FaceBook", identifier: accessToken.userId!)
                
            }
        }
    }
    @IBAction func googleButtonCliked(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self as GIDSignInDelegate
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().uiDelegate = self as GIDSignInUIDelegate
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func calSocialSingin(type:String,identifier:String) {
        self.showActivityIndicator()
        UserAPI.sharedAPI.performSocialLogin(provider:type, identifier:identifier, method: "POST", successHandler: {
            self.pushDashboardVC()
             self.hideActivityIndicator()
        }, failureHandler: { errorMessage in
            self.hideActivityIndicator()
            if errorMessage == "Account does not exist." {
                if self.socialSignupType == "FaceBook" {
                    self.getFaceBookUserDetails()
                }else{
                    self .pushSocialSingupVC()
                }
                
            }else{
                
            }
        }, env: .dev)
        
    }
    
    func calSocialSignup(provider:String,identifier:String,name:String,phoneNumber:String,email:String,device:String,referalCode:String,profilePic:String,gender:String,dob:String) {
        
        
    }
    
    func pushSocialSingupVC() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let socialSignUpVC = storyBoard.instantiateViewController(withIdentifier: "SocialSignupController") as! SocialSignupController
        socialSignUpVC.name = self.name
        socialSignUpVC.email = self.email
        socialSignUpVC.identifier = self.identifier
        socialSignUpVC.provider = self.socialSignupType
        socialSignUpVC.phoneNumber = ""
        self.navigationController?.pushViewController(socialSignUpVC, animated: true)
    }
    
    func pushDashboardVC()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showDashBoard()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Dashboard", bundle:nil)
//        let dashboardVC = storyBoard.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
//        self.navigationController?.pushViewController(dashboardVC, animated: true)
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        //print("Sign in presented")
    }
    
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
            self.socialSignupType = "Google"
            self.identifier = user.userID
            self.name = user.profile.name
            self.email = user.profile.email
            self.googleUser = user
            self.calSocialSingin(type: "Google", identifier: user.userID)
        }
        
       
    }
    
}
