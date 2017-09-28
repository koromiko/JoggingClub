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
}

class JogDetailViewController: UIViewController, JogDetailViewControllerProtocol {

    var viewModel: JogDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewIsReady()
    }
    
    func updateView() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
