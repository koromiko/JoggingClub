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
        
        // given a stub with 3 event
        // when fetch jog event
        let expect = XCTestExpectation(description: "jog event callback")
        
        sut!.fetchJogEvent(complete: { (success, events, error) in
            XCTAssertEqual(events.count, 3)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 1)
    }
    
    func test_add_a_job_event() {
        
    }
    
    func test_remove_a_jog_event() {
        
    }
    
    func test_edit_a_jog_event() {
        
    }

    
    
    
}

extension APIServiceTests {
    func initStubs(){
        
        stub(condition: isPath( "/\(APIPath.jogEvent)") ) { (_) -> OHHTTPStubsResponse in
            let stubPath = OHPathForFile("jogEvent.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }
    
    func clearStubs() {
        OHHTTPStubs.removeAllStubs()
    }
}




