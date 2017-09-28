//
//  APIServiceTests.swift
//  JoggingClubTests
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import JoggingClub

class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
        initStubs()
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    
    func test_fetch_jog_list() {
        
        // given a stub with n event
        let json: Any = StubHelper().loadJSONResource(name: "jogEvent")
        let jsonDic = json as! [String: Any]
        
        // when fetch jog event
        let expect = XCTestExpectation(description: "jog event callback")
        
        sut!.fetchJogEvent(authType: AuthType.general, complete: { (success, events, error) in
            XCTAssertEqual(events.count, jsonDic.keys.count)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 1)
    }
    
    func test_add_a_job_event() {
        
        // Give a event
        let event = StubHelper().loadEvent()
        
        let expect = XCTestExpectation(description: "add api is called")
        
        //When call add to api service
        sut!.add( event ) { success in
            expect.fulfill()
            XCTAssertTrue(success)
        }
        
        // url is correct
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_remove_a_jog_event() {
        
    }
    
    func test_edit_a_jog_event() {
        
    }

    
    
    
}

extension APIServiceTests {
    func initStubs(){
        
        stub(condition: isMethodGET() && isPath( "/\(APIPath.jogEventForGeneralUser)") ) { (_) -> OHHTTPStubsResponse in
            let stubPath = OHPathForFile("jogEvent.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        stub(condition: isMethodPOST() && isPath("/\(APIPath.jogEventAdd)")) { request -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse( jsonObject: ["name": "-Kv1qaWAp66vkZEdSuXq"],
                                        statusCode: 200,
                                        headers: [ "Content-Type": "application/json" ])
        }
        
    }
    
    func clearStubs() {
        OHHTTPStubs.removeAllStubs()
    }
}

