//
//  JogDetailViewController.swift
//  JoggingClub
//
//  Created by Neo on 27/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import UIKit
protocol JogDetailViewControllerProtocol: class {
    func updateView()
    func updateLoadingState( isLoading: Bool )
    func leave()
    func showError(message: String)
}

class JogDetailViewController: UIViewController, JogDetailViewControllerProtocol {

    var viewModel: JogDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewIsReady()
    }
    
    func updateView() {
        
    }
    
    func updateLoadingState(isLoading: Bool) {
        
    }
    
    func leave() {

    }
    
    func showError(message: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
