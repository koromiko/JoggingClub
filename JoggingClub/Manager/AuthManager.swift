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
}

class AuthManager {
    
    // Dependency for auth methods in Firebase
    let auth: FirebaseAuthProtocol
    
    init(auth: FirebaseAuthProtocol) {
        self.auth = auth
        
    }
    
    convenience init(){
        self.init(auth: Auth.auth())
    }
    
    //MARK: Account login/signup
    func sighUp( email: String, password: String, complete: @escaping (_ success: Bool, _ token: String?)->() ) {
        auth.createUser(withEmail: email, password: password) { (user, error) in
            if let token = user?.refreshToken {
                complete( true, token )
            }else {
                complete( false, nil )
            }
        }
    }

    //MARK: Auth add/remove/edit/query
    
}

extension Auth: FirebaseAuthProtocol {}
