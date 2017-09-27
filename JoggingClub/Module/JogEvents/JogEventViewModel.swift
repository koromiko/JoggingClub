//
//  JogEventViewModel.swift
//  JoggingClub
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

struct JogEventsDisplayItem {
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

class JogEventsViewModel {

    var api: APIServiceProtocol
    var authManager: AuthManagerProtocol
    weak var delegate: JogEventsViewControllerProtocol?
    
    var displayItems: [JogEventsDisplayItem] = [JogEventsDisplayItem]()
    
    var fromDate: Date?
    var toDate: Date?
    
    init( api: APIServiceProtocol = APIService(),
          authManager: AuthManagerProtocol = AuthManager() ) {
        self.api = api
        self.authManager = authManager
    }
    
    func viewWillAppear() {
        api.fetchJogEvent(authType: authManager.authType) { [weak self] (success, events, error) in
            self?.updateEvents(events)
        }
    }
    
    func updateEvents( _ events: [JogEvent] ) {
        self.delegate?.reloadTableView()
        
        var filteredEvents = filterEvent(events: events, with: authManager.authType)
        
        if authManager.authType == .general {
            if let uid = authManager.uid {
                filteredEvents = filterEvent(events: filteredEvents, with: uid)
            }
        }
        
        if let from = fromDate, let to = toDate {
            filteredEvents = filterEvent(events: filteredEvents, from: from, to: to)
        }
        
        self.displayItems = packDisplayItems(from: filteredEvents)
    }
    
    
    //MARK: private methods
    private func packDisplayItems(from events: [JogEvent] ) -> [JogEventsDisplayItem] {
        var mutableItems = [JogEventsDisplayItem]()
        for event in events {
            let item = JogEventsDisplayItem(event: event)
            mutableItems.append(item)
        }
        return mutableItems
    }
    
    private func filterEvent( events: [JogEvent], from: Date, to: Date ) -> [JogEvent]{
        return events.filter { $0.date >= from && $0.date <= to }
    }
    
    private func filterEvent( events:[JogEvent], with type: AuthType ) -> [JogEvent] {
        return events.filter { $0.user.authType <= type.rawValue }
    }
    
    private func filterEvent( events:[JogEvent], with uid: String ) -> [JogEvent] {
        return events.filter { $0.user.id == uid }
    }
    
}
