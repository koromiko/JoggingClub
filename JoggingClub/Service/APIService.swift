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
                   let events = try decoder.decode([JogEvent].self, from: data)
                    complete( true, events, nil )
                } catch {
                    complete( true, [JogEvent](), APIError.unknownError(error.localizedDescription) )
                }
                
            }else {
                complete( false, [JogEvent](), APIError.unknownError( response.error?.localizedDescription ?? "Unknown" ) )
            }
            

        }
    }
    
}
