//
//  JogEvent.swift
//  JoggingClub
//
//  Created by Neo on 24/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

struct JogEvent: Codable {
    struct User: Codable {
        let id: String
        let account: String
        let authType: Int
    }
    let distance: Float
    let duration: Int
    let date: Date
    let user: User
    let id: String?
}

struct JogEvents: Codable {
    struct JogEventKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) {
            return nil
        }
        
        static let distance = JogEventKey(stringValue: "distance")!
        static let duration = JogEventKey(stringValue: "duration")!
        static let date = JogEventKey(stringValue: "date")!
        static let user = JogEventKey(stringValue: "user")!
    }
    
    let jogEvents: [JogEvent]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JogEventKey.self)
        
        var events: [JogEvent] = []
        for key in container.allKeys {
            let nested = try container.nestedContainer(keyedBy: JogEventKey.self,
                                                       forKey: key)
            let distance = try nested.decode(Float.self, forKey: .distance)
            let duration = try nested.decode(Int.self, forKey: .duration)
            let date = try nested.decode(Date.self, forKey: .date)
            let user = try nested.decode(JogEvent.User.self, forKey: .user)
            
            let e = JogEvent( distance: distance,
                              duration: duration,
                              date: date,
                              user: user,
                              id: key.stringValue )
            events.append(e)
        }
        
        self.jogEvents = events
        
    }
}
