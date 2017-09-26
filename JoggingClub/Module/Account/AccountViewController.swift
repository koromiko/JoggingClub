//
//  AccountViewController.swift
//  JoggingClub
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import UIKit

protocol AccountViewControllerDelegate: class {
    func dismiss()
    func setTitle( title: String )
    func setSubmitButtonTitle( title: String )
    func setLoading( isLoading: Bool )
    func setButtonEnabled( isEnabled: Bool )
}

class AccountViewController: UIViewController, AccountViewControllerDelegate {
    
    let viewModel: AccountViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTitle(title: String) {
        
    }
    
    func setSubmitButtonTitle(title: String) {
        
    }
    
    func setLoading(isLoading: Bool) {
        
    }
    
    func setButtonEnabled(isEnabled: Bool) {
        
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
