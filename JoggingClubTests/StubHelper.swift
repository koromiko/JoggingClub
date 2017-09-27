//
//  StubHelper.swift
//  JoggingClubTests
//
//  Created by Neo on 27/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

class StubHelper {
    func loadJSONResource(name: String) -> Any {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: name, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json
    }
    
    func loadJSONResource(name: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: name, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return data
    }
}
