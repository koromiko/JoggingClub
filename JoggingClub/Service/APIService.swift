//
//  APIService.swift
//  JoggingClub
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
import Alamofire

enum APIHost {
    static let base: String = "https://joggingclub-862d2.firebaseio.com/"
}

enum APIPath {
    static let jogEventForGeneralUser = "jog_event.json"
    static let jogEventForManager = "jog_event.json"
    static let jogEventForAdministrator = "jog_event.json"
    static let jogEventAdd = "jog_event.json"
    static let jogEventDelete = "jog_event"
    static let jogEventEdit = "jog_event"
}

enum APIError {
    case unknownError (String)
}

protocol APIServiceProtocol {
    func fetchJogEvent( authType: AuthType, complete: @escaping (_ success: Bool, _ jogEvents: [JogEvent], _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    
    func fetchJogEvent( authType: AuthType, complete: @escaping (_ success: Bool, _ jogEvents: [JogEvent], _ error: APIError? )->() ) {
        
        var url: String = APIHost.base
        switch authType {
        case .general:
            url.append( APIPath.jogEventForGeneralUser )
        case .manager:
            url.append( APIPath.jogEventForManager )
        case .administrator:
            url.append( APIPath.jogEventForAdministrator )
        }
        
        Alamofire.request( url ).responseData { (response) in
            
            if let data = response.result.value {
                
                let decoder = JSONDecoder()
                do {
                   let events = try decoder.decode(JogEvents.self, from: data)
                    
                    complete( true, events.jogEvents, nil )
                } catch {
                    complete( true, [JogEvent](), APIError.unknownError(error.localizedDescription) )
                }
                
            }else {
                complete( false, [JogEvent](), APIError.unknownError( response.error?.localizedDescription ?? "Unknown" ) )
            }
            

        }
    }
    
    
    func add( _ event: JogEvent, complete: @escaping (_ success: Bool)->() ) {
        
        let encoder = JSONEncoder()
        if let paramData = try? encoder.encode(event) {
            if let param = try? JSONSerialization.jsonObject(with: paramData, options: []) as? [String: Any] {
                let url = String( format: "\(APIHost.base)\(APIPath.jogEventAdd)")
                Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default )
                    .validate()
                    .responseJSON(completionHandler: { (response) in

                        if response.result.isSuccess {
                            complete( true )
                        }else {
                            complete( false )
                        }
                    })
            }
            
            
        }
    }
    
    func remove( _ event: JogEvent, complete: @escaping (_ success: Bool )->() ) {
        
        guard let eventID = event.id else {
            complete(false)
            return
        }

        let url = "\(APIHost.base)\(APIPath.jogEventDelete)/\(eventID).json"
        
        Alamofire.request(url, method: .delete, parameters: nil).responseJSON { ( response ) in
            if response.result.isSuccess {
                complete(true)
            }else {
                complete(false)
            }
        }

    }
    
    func edit( _ event: JogEvent, complete: @escaping (_ success: Bool )->() ) {
        
        guard let eventID = event.id else {
            complete(false)
            return
        }
        
        let url = "\(APIHost.base)\(APIPath.jogEventEdit)/\(eventID).json"
        
        Alamofire.request(url, method: .put, parameters: nil).responseJSON { ( response ) in
            if response.result.isSuccess {
                complete(true)
            }else {
                complete(false)
            }
        }
    }
    
}
