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
        
    }
    
    override func tearDown() {
        sut = nil 
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func test_fetch_jog_list() {
        
        // given a stub with n events
        let json: Any = StubHelper().loadJSONResource(name: "jogEvent")
        let jsonDic = json as! [String: Any]
        
        // Prepare stubs
        stub(condition: isMethodGET() && isPath( "/\(APIPath.jogEventForGeneralUser)") ) { (_) -> OHHTTPStubsResponse in
            let stubPath = OHPathForFile("jogEvent.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        // when fetch jog event
        let expect = XCTestExpectation(description: "jog event callback")
        
        sut!.fetchJogEvent(authType: AuthType.general, complete: { (success, events, error) in
            XCTAssertEqual(events.count, jsonDic.keys.count)
            for e in events {
                XCTAssertNotNil(e.id)
            }
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 1)
    }
    
    func test_add_a_job_event() {
        
        // Give a event
        let event = JogEvent( distance: 3200,
                              duration: 2100,
                              date: Date(),
                              user: JogEvent.User(id: "1", account: "user@wer.we", authType: 1),
                              id: nil)
        // Prepare stubs
        stub(condition: isMethodPOST() && isPath("/\(APIPath.jogEventAdd)")) { request -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse( jsonObject: ["name": "-Kv1qaWAp66vkZEdSuXq"],
                                        statusCode: 200,
                                        headers: [ "Content-Type": "application/json" ])
        }
        
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
        // Given a existing event
        let event = StubHelper().loadEvent()
        
        let expect = XCTestExpectation(description: "Remove callback")
        let callExpect = XCTestExpectation(description: "Delete request sent")
        
        stub(condition: isMethodDELETE() && isPath("/\(APIPath.jogEventDelete)/\(event.id!).json") ) { request -> OHHTTPStubsResponse in
            callExpect.fulfill()
            return OHHTTPStubsResponse( jsonObject: ["name": "-Kv1qaWAp66vkZEdSuXq"],
                                        statusCode: 200,
                                        headers: [ "Content-Type": "application/json" ])
        }
        
        // When remove a event
        sut!.remove( event ) { success in
            expect.fulfill()
            XCTAssert(success)
        }
        
        // Assert call and callback
        wait(for: [expect, callExpect], timeout: 1.0)
    }
    
    func test_edit_a_jog_event() {
        
        // Given a existing event
        let event = StubHelper().loadEvent()
        
        let expect = XCTestExpectation(description: "Edit callback")
        let callExpect = XCTestExpectation(description: "Edit request sent")
        
        stub(condition: isMethodPUT() && isPath("/\(APIPath.jogEventDelete)/\(event.id!).json") ) { request -> OHHTTPStubsResponse in
            callExpect.fulfill()
            return OHHTTPStubsResponse( jsonObject: ["name": "-Kv1qaWAp66vkZEdSuXq"],
                                        statusCode: 200,
                                        headers: [ "Content-Type": "application/json" ])
        }
        
        // When remove a event
        sut!.edit( event ) { success in
            expect.fulfill()
            XCTAssert(success)
        }
        
        // Assert call and callback
        wait(for: [expect, callExpect], timeout: 1.0)
    }
    
}

