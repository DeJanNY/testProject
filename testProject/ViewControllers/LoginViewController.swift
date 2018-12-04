//
//  LoginViewController.swift
//  testProject
//
//  Created by Dejan Krstevski on 12/3/18.
//  Copyright © 2018 dejan. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
let kCloseNotification = "kCloseNotification"


class LoginViewController: UIViewController, SFSafariViewControllerDelegate {

    var safariVC: SFSafariViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(safariLogin),
                                               name: NSNotification.Name(rawValue: kCloseNotification),
                                               object: nil)
    }


    @IBAction func loginButton(_ sender: Any) {
        if let stringUrl = "https://github.com/login/oauth/authorize?scope=\(LoginCredentials.sharedInstance.scope)&client_id=\(LoginCredentials.sharedInstance.client_id)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed), let url = URL(string: stringUrl) {
            safariVC = SFSafariViewController(url: url)
            safariVC!.delegate = self
            self.present(safariVC!, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func safariLogin(notification: NSNotification) {
        // returned url from Github
        let url = notification.object as! NSURL
        
        // returned code
        let code = self.getParameterFrom(url: String(describing: url), param: "code")
        
        // parameters for access token request
        let parameters = ["client_id": LoginCredentials.sharedInstance.client_id, "client_secret": LoginCredentials.sharedInstance.client_secret, "code": code!, "accept": "application/json"] as [String : Any]
        
        // get access token from Github with the code
        Alamofire.request(LoginCredentials.sharedInstance.token_uri, method: .post, parameters: parameters).responseString { response in
            
            if let result = response.result.value, let makeItUrl = NSURL(string: "https://api.github.com/?\(result)") {
                
                if let access_code = self.getParameterFrom(url: String(describing: makeItUrl), param: "access_token") {
                    // # here is the access token # //
                    LoginCredentials.sharedInstance.token = access_code
                    UserDefaults.standard.setValue(access_code as String, forKey: "userToken")
                    
                }
            }
            
        }
        
        // dismiss the Safari View Controller
        self.safariVC!.dismiss(animated: true, completion: nil)
        loginSuccessful()
    }
    
    // parse the parameters from the url string
    func getParameterFrom(url: String, param: String) -> String? {
        
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        // dismiss the SafariViewController
        controller.dismiss(animated: true)
    }
    
    @objc func loginSuccessful() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
