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
        distanceText = String( format: "%.1f m", event.distance )
        durationText = String( format: "%d s", event.duration )
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
    var api: APIServiceProtocol?
    
    var mode: JogDetailViewMode = JogDetailViewMode.add
    
    private let event: JogEvent?

    var displayItem: JogDetailDisplayItem? {
        didSet {
            self.delegate?.updateView()
        }
    }
    
    init(api: APIServiceProtocol = APIService(), event: JogEvent?, mode: JogDetailViewMode) {
        self.api = api
        self.event = event
        self.mode = mode
    }
    
    func viewIsReady() {
        if mode == JogDetailViewMode.edit {
            if let event = event {
                self.displayItem = JogDetailDisplayItem(event: event)
            }
        }
    }
    
    func userClickDone() {
        
    }
    
}

