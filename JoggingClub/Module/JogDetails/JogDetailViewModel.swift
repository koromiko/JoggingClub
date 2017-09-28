//
//  JogDetailViewModel.swift
//  JoggingClub
//
//  Created by Neo on 27/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

struct JogDetailDisplayItem {
    let distanceText: String
    let durationText: String
    let usernameText: String
    let userTypeText: String
    let dateText: String
    
    init( event: JogEvent ) {
        distanceText = String( format: "%.1f", event.distance )
        durationText = String( format: "%d", event.duration )
        usernameText = event.user.account
        switch event.user.authType {
        case AuthType.general.rawValue:
            userTypeText = "👨"
            break
        case AuthType.manager.rawValue:
            userTypeText = "👨‍🏭"
            break
        case AuthType.administrator.rawValue:
            userTypeText = "🔑"
            break
        default:
            userTypeText = "Unknown"
            break
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateText = dateFormatter.string(from: event.date)
    }
}

enum JogDetailViewMode {
    case add
    case edit
}

class JogDetailViewModel {
    
    weak var delegate: JogDetailViewControllerProtocol?
    
    var api: APIServiceProtocol
    var mode: JogDetailViewMode = JogDetailViewMode.add
    var auth: AuthManagerProtocol
    
    var isLoading: Bool = false {
        didSet {
            self.delegate?.updateLoadingState( isLoading: isLoading)
        }
    }

    var event: JogEvent? {
        didSet {
            if let event = self.event {
                self.displayItem = JogDetailDisplayItem(event: event)
            }
        }
    }

    var displayItem: JogDetailDisplayItem? {
        didSet {
            self.delegate?.updateView()
        }
    }
    
    init( api: APIServiceProtocol = APIService(),
          authManager: AuthManagerProtocol = AuthManager(),
          mode: JogDetailViewMode ) {
        self.api = api
        self.mode = mode
        self.auth = authManager
    }
    
    func viewIsReady() {
        if mode == JogDetailViewMode.add {
            guard let uid = auth.uid, let account = auth.account else {
                return
            }
            
            let user = JogEvent.User(id: uid, account: account, authType: auth.authType.rawValue)
            let event = JogEvent(distance: 0.0, duration: 0, date: Date(), user: user, id: nil)
            self.event = event
        }
    }
    
    func userClickDone( inputDistance: String, inputDuration: String, inputDate: Date ) {
        
        // Check data avaliability
        guard let distance = Float(inputDistance), let duration = Int(inputDuration) else {
            self.delegate?.showError(message: "Please fill in data")
            return
        }
        
        if distance == 0.0 || duration == 0 {
            self.delegate?.showError(message: "Please input valid data")
            return
        }
        
        if mode == JogDetailViewMode.add {
            
            guard let uid = auth.uid, let account = auth.account else {
                self.delegate?.showError(message: "User not logged in!")
                return
            }
            
            let user = JogEvent.User(id: uid, account: account, authType: auth.authType.rawValue)
            
            let event = JogEvent(distance: distance, duration: duration, date: inputDate, user: user, id: nil)
            isLoading = true
            api.add(event, complete: { [weak self] (success) in
                self?.isLoading = false
                if success {
                    self?.delegate?.leave()
                }else {
                    self?.delegate?.showError(message: "Add Event Error!")
                }
            })
            
            
        }else if mode == JogDetailViewMode.edit {
            guard let event = event else {
                fatalError("Inject Event Error")
            }
            
            let editedEvent = JogEvent(distance: distance, duration: duration, date: inputDate, user: event.user, id: event.id! )

            isLoading = true
            api.edit( editedEvent, complete: { [weak self] (success) in
                self?.isLoading = false
                self?.delegate?.leave()
            })
        
        }
    }
    
}

