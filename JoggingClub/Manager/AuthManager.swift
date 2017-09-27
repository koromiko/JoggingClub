//
//  AuthManager.swift
//  JoggingClub
//
//  Created by Neo on 25/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseAuthProtocol {
    func createUser(withEmail email: String, password: String, completion: AuthResultCallback? )
    func signIn(withEmail email: String, password: String, completion: AuthResultCallback? )
    func signOut() throws
}

protocol AuthManagerProtocol {
    var isLoggedIn: Bool { get set }
    var authType: AuthType { get set }
    var uid: String? { get set }
    var account: String? { get set }
    
    func logIn( email:String, password: String, complete: @escaping ( _ success: Bool, _ error: AuthError? )->() )
    func sighUp( email: String, password: String, complete: @escaping (_ success: Bool, _ error: AuthError? )->() )
    func logout()
}

enum AuthType: Int {
    case general = 1
    case manager = 2
    case administrator = 3
}

enum AuthError {
    case unknowmError
    case accountAlreadyExists
    case accountNotExists
    case wrongPassword
}

class AuthManager: AuthManagerProtocol {
    
    
    var isLoggedIn: Bool = false
    
    var uid: String?
    var account: String?
    var authType: AuthType = AuthType.general
    
    // Dependency for auth methods in Firebase
    let auth: FirebaseAuthProtocol
    
    var token: String?
    
    var loggedInUser: User?
    
    
    
    init(auth: FirebaseAuthProtocol) {
        self.auth = auth
    }
    
    convenience init(){
        self.init(auth: Auth.auth())
    }
    
    //MARK: Account login/signup
    func sighUp( email: String, password: String, complete: @escaping (_ success: Bool, _ error: AuthError? )->() ) {
        auth.createUser(withEmail: email, password: password) { (user, error) in
            if let token = user?.refreshToken {
                self.token = token
                complete( true, nil )
            }else {
                complete( false, AuthError.unknowmError )
            }
        }
    }

    func logIn( email:String, password: String, complete: @escaping ( _ success: Bool, _ error: AuthError? )->() ) {
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let token = user?.refreshToken {
                self.token = token
                complete( true, nil )
            }else{
                complete( false, AuthError.unknowmError)
            }
        }
    }
    
    func logout() {
        try? auth.signOut()
    }
    
    //MARK: Auth add/remove/edit/query
    
    
    
    
}

extension Auth: FirebaseAuthProtocol {}
