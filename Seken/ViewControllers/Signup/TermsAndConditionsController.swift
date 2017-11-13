//
//  TermsAndConditionsController.swift
//  Seken
//
//  Created by Seken InfoSys on 10/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

class TermsAndConditionsController: SekenViewController,UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Terms and Conditions"
        self.setBackBarButtonCustom()
        
        let myWebView:UIWebView = UIWebView(frame: CGRect(x:0, y:50, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height-50))
        myWebView.delegate = self as UIWebViewDelegate
        self.view.addSubview(myWebView)
        
        let myURL = URL(string: "http://dev.seken.com/seken-qa/en/terms-privacy")
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        myWebView.loadRequest(myURLRequest)
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        self.showActivityIndicator()
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.hideActivityIndicator()
    }

  

}
