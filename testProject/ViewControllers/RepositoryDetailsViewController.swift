//
//  RepositoryDetailsViewController.swift
//  testProject
//
//  Created by Dejan Krstevski on 12/4/18.
//  Copyright © 2018 dejan. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class RepositoryDetailsViewController: UIViewController {
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var commitsLabel: UILabel!
    @IBOutlet var forksLabel: UILabel!
    @IBOutlet var branchesLabel: UILabel!
    
    var repository: Repository!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(backTapped))
        title = repository.name
        starsLabel.text = String(repository.stargazers_count)
        forksLabel.text = String(repository.forks_count)
        getCommits()
        getBranches()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func getCommits(){
    let url = URL(string: "https://api.github.com/repos/\(repository.owner.login)/\(repository.name)/contributors")!
        
        Alamofire.request(url, method: .get, parameters: nil).responseString { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let commits = try JSONDecoder().decode([Contribution].self, from: data)
                        if !commits.isEmpty {
                            var fullCommits = 0
                            for com in commits {
                              fullCommits=fullCommits + com.contributions
                            }
                            self.commitsLabel.text = String(fullCommits)
                        }
                    } catch {
                        print("no contributions")
                    }
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func getBranches(){
        let url = URL(string: "https://api.github.com/repos/\(repository.owner.login)/\(repository.name)/branches")!
        
        Alamofire.request(url, method: .get, parameters: nil).responseString { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let branches = try JSONDecoder().decode([Branch].self, from: data)
                        if !branches.isEmpty {
                            self.branchesLabel.text = String(branches.count)
                        }
                    } catch {
                        print("no branches")
                    }
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
}
