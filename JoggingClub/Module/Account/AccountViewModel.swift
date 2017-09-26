//
//  AccountViewModel.swift
//  JoggingClub
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

enum AccountViewState {
    case loading
    case login
    case signup
}

class AccountViewModel {

    var auth: AuthManagerProtocol
    
    weak var delegate: AccountViewControllerDelegate?
    
    init( auth: AuthManagerProtocol = AuthManager(), delegate: AccountViewControllerDelegate? ) {
        self.auth = auth
        self.delegate = delegate
    }

    func viewIsReady() {
        
        if auth.isLoggedIn {
            delegate?.dismiss()
        }
    }
    
    func initView() {
        
    }
}
