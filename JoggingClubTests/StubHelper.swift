//
//  StubHelper.swift
//  JoggingClubTests
//
//  Created by Neo on 27/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
@testable import JoggingClub

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
    
    func loadStubJogEvents(name: String) -> [JogEvent] {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: name, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        var mutableEvents = [JogEvent]()
        for key in json.keys {
            let value = json[key] as! [String:Any]
            mutableEvents.append( createJogEvent(key: key, value: value) )
        }
        return mutableEvents
    }
    
    func loadEvent() -> JogEvent {
        let data: Data = StubHelper().loadJSONResource(name: "jogEvent")
        let jsons = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        let key = jsons.keys.first!
        let value = jsons[key] as! [String: Any]
        return createJogEvent(key: key, value: value)
    }
    
    
    //MARK: Private
    private func createJogEvent( key: String, value: [String: Any] ) -> JogEvent {
        let distance = value["distance"] as! Float
        let duration = value["duration"] as! Int
        let userObj = value["user"] as! [String:Any]
        let user = JogEvent.User( id: userObj["id"] as! String,
                                  account: userObj["account"] as! String,
                                  authType: userObj["authType"] as! Int )
        let ticks = value["date"] as! Double
        let date = Date(timeIntervalSince1970: ticks/10_000_000 - 62_135_596_800 )
        
        return JogEvent( distance: distance,
                         duration: duration,
                         date: date,
                         user: user,
                         id: key )
    }
}
