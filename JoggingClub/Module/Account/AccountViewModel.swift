//
//  AccountViewModel.swift
//  JoggingClub
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

enum AccountViewState {
    case login
    case signup
}

class AccountViewModel {

    var auth: AuthManagerProtocol
    
    var email: String?
    var password: String?
    
    var state: AccountViewState = .login {
        didSet {
            self.delegate!.setTitle(title: self.titleForState(state: self.state))
            self.delegate!.setSubmitButtonTitle(title: self.titleForState(state: self.state))
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.delegate!.setLoading(isLoading: self.isLoading )
            self.delegate!.setButtonEnabled(isEnabled: !self.isLoading )
        }
    }
    
    weak var delegate: AccountViewControllerDelegate?
    
    init( auth: AuthManagerProtocol = AuthManager(), delegate: AccountViewControllerDelegate? ) {
        self.auth = auth
        self.delegate = delegate
    }

    func viewIsReady() {
        if auth.isLoggedIn {
            delegate?.dismiss()
        }else {
            self.state = AccountViewState.login
        }
    }
    
    func userClickSignUpButton() {
        self.state = AccountViewState.signup
    }
    
    func userClickLoginButton() {
        self.state = AccountViewState.login
    }
    
    func userClickSubmit() {
        
        if let email = self.email, let password = self.password {
            if state == AccountViewState.login {
                self.isLoading = true
                auth.logIn(email: email, password: password, complete: { [unowned self] (success, error) in
                    if error != nil {
                        self.loginComplete()
                    }
                })
                
            }else if state == AccountViewState.signup {
                self.isLoading = true
                auth.sighUp(email: email, password: password, complete: { (success, error) in
                    
                })
            }
        }else {
        
        }
    }
    
    func loginComplete(){
        self.delegate?.dismiss()
    }
    
    func signupComplete() {
        self.delegate?.dismiss()
    }

    //MARK: Private text
    private func titleForState( state: AccountViewState ) -> String {
        switch state {
        case .login:
            return "Login"
        case .signup:
            return "Signup"
        }
    }
    
    
    
}
