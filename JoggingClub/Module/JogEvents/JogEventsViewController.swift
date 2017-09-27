//
//  JogEventsViewController.swift
//  JoggingClub
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import UIKit


protocol JogEventsViewControllerProtocol: class {
    func reloadTableView()
}

class JogEventsViewController: UIViewController, JogEventsViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: JogEventsViewModel = {
        return JogEventsViewModel(api: APIService(), authManager: AuthManager())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension JogEventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "jogEventCellIdentifier", for: indexPath) as? JogEventsTableViewCell else { fatalError("Cell not found") }
        
        let item = viewModel.displayItems[indexPath.row]
        
        cell.dateLabel.text = item.dateText
        cell.authLabel.text = item.userTypeText
        cell.durationLabel.text = item.durationText
        cell.distanceLabel.text = item.distanceText
        cell.userLabel.text = item.usernameText

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension JogEventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //Goto next screen
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .default, title: "Remove") { (action, indexPath) in
            
        }
        return [action]
    }

}

class JogEventsTableViewCell: UITableViewCell {
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var authLabel: UILabel!
    
}
