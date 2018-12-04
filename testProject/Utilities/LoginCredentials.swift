//
//  LoginCredentials.swift
//  testProject
//
//  Created by Dejan Krstevski on 12/3/18.
//  Copyright © 2018 dejan. All rights reserved.
//

import Foundation

class LoginCredentials {
    static let sharedInstance = LoginCredentials()
    var token = ""
    let client_id = "Iv1.449e9a840d84d07a"
    let client_secret = "c2b80eaa9cd45ef50acf30ebf125fb5028cc60ff"
    let scope = "user repo:status"
    let redirect_uris = ["githuboauth://oauth/callback"]
    let token_uri = "https://github.com/login/oauth/access_token"
    let user_uri = "https://api.github.com/users/"

}
