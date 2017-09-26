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
    static let jogEvent = "jog_event.json"
}

enum APIError {
    case unknownError (String)
}

class APIService {
    
    func fetchJogEvent( complete: @escaping (_ success: Bool, _ jogEvents: [JogEvent], _ error: APIError? )->() ) {

        Alamofire.request( APIHost.base.appending(APIPath.jogEvent) ).responseData { (response) in
            
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
