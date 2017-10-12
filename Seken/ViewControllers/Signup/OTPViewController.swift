//
//  OTPViewController.swift
//  Seken
//
//  Created by Seken InfoSys on 09/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

class OTPViewController: SekenViewController {

    @IBOutlet weak var txtOTP1: UITextField!
    
    @IBOutlet weak var txtOTP2: UITextField!
    
    @IBOutlet weak var txtOTP3: UITextField!
    
    @IBOutlet weak var txtOTP4: UITextField!
    
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

    func textFieldShouldClear(textField: UITextField) -> Bool {
        //println("TextField should clear method called")
        return true;
    }
    

}
