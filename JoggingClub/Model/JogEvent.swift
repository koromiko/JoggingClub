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
    
    
}
