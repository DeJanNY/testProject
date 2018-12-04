//
//  ViewController.swift
//  testProject
//
//  Created by Dejan Krstevski on 12/3/18.
//  Copyright © 2018 dejan. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = UserDefaults.standard.value(forKey: "userToken") {
            LoginCredentials.sharedInstance.token = token as! String
        } else {
            self.showLoginFlow()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       usernameTextField.text = ""
    }
    
    
    func getRepositoriesForUser(user: String){

            let url = URL(string: "https://api.github.com/users/\(user)/repos?access_token=\(LoginCredentials.sharedInstance.token)")!
            
            Alamofire.request(url, method: .get, parameters: nil).responseString { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let repos = try JSONDecoder().decode([Repository].self, from: data)
                            if !repos.isEmpty {
                                let userVC = RepositoriesViewController(repositories: repos)
                                self.navigationController?.pushViewController(userVC, animated: true)
                            }
                        } catch {
                            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        }
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        
    }
    

    func showLoginFlow() {
        self.performSegue(withIdentifier: "main_to_login", sender: self)
    }

    @IBAction func didTapSearchRepositories(_ sender: Any) {
        if LoginCredentials.sharedInstance.token.count > 0 {
            if !((usernameTextField.text?.isEmpty)!) {
                getRepositoriesForUser(user: usernameTextField.text!)
        }
        } else {
        self.showLoginFlow()
        }
    }
    
    @IBAction func didTapLogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userToken")
        self.showLoginFlow()
    }


}

