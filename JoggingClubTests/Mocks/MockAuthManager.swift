//
//  MockAuthManager.swift
//  JoggingClubTests
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
@testable import JoggingClub

class MockAuthManager: AuthManagerProtocol {
    
    var isLoggedIn: Bool = false
    var authType: AuthType = AuthType.general
    var uid: String?
    var account: String?
    
    var isLoginGetCalled: Bool = false
    var isSignUpCalled: Bool = false
    var isLogoutCalled = true
    
    var submittedEmail: String?
    var submittedPassword: String?
    
    func sighUp(email: String, password: String, complete: @escaping (Bool, AuthError?) -> ()) {
        isSignUpCalled = true
        submittedEmail = email
        submittedPassword = password
    }
    
    func logIn(email: String, password: String, complete: @escaping (Bool, AuthError?) -> ()) {
        isLoginGetCalled = true
        submittedEmail = email
        submittedPassword = password
    }
    
    func logout() {
        isLogoutCalled = true
    }
}
