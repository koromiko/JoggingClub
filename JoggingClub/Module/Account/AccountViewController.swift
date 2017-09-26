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
    
    lazy var viewModel: AccountViewModel = {
        return AccountViewModel(auth: AuthManager(), delegate: self)
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if self.segmentView.selectedSegmentIndex == 0 {
            viewModel.userClickLoginButton()
        }else {
            viewModel.userClickSignUpButton()
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        viewModel.email = self.accountTextField.text
        viewModel.password = self.passwordTextField.text
        viewModel.userClickSubmit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewIsReady()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTitle(title: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = title
        }
    }
    
    func setSubmitButtonTitle(title: String) {
        DispatchQueue.main.async {
            self.submitBtn.setTitle(title, for: UIControlState.normal)
        }
    }
    
    func setLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.loadingView.startAnimating()
            }else {
                self.loadingView.stopAnimating()
            }
        }
    }
    
    func setButtonEnabled(isEnabled: Bool) {
        DispatchQueue.main.async {
            self.submitBtn.isEnabled = isEnabled
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
