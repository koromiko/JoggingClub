//
//  User.swift
//  JoggingClub
//
//  Created by Neo on 24/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

enum UserRule: Int {
    case general = 0
    case manager = 1
    case administrator = 2
}

struct User {
    let name: String
    let rule: UserRule
    
}
