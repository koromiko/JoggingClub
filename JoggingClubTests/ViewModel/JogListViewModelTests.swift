//
//  JogListViewModelTests.swift
//  JoggingClubTests
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
@testable import JoggingClub

class JogListViewModelTests: XCTestCase {

    var mockAPI: MockAPIService?
    var mockAuthManager: MockAuthManager?
    var mockJogEventsViewCtontroller: MockJogEventsViewController?
    
    var sut: JogEventsViewModel?
    
    override func setUp() {
        super.setUp()
        mockAPI = MockAPIService()
        mockAuthManager = MockAuthManager()
        mockJogEventsViewCtontroller = MockJogEventsViewController()
        sut = JogEventsViewModel( api: mockAPI!, authManager: mockAuthManager! )
        sut!.delegate = mockJogEventsViewCtontroller
    }
    
    override func tearDown() {
        sut = nil
        mockAPI = nil
        mockAuthManager = nil
        mockJogEventsViewCtontroller = nil
        super.tearDown()
    }

    func test_list_jog_item_for_general_user() {
        // Given user logged in with type auth general and id = 1
        mockAuthManager!.authType = AuthType.general
        mockAuthManager!.uid = "1"
        
        let data: Data = StubHelper().loadJSONResource(name: "jogEvent")
        let decoder = JSONDecoder()
        let events = try! decoder.decode([JogEvent].self, from: data)
        
        //When viewWillAppear
        sut!.updateEvents(events)
        
        //trigger fetch jog events
        XCTAssertEqual( sut!.displayItems.count, events.filter { $0.user.authType <= 1 && $0.user.id == "1" }.count )
        
    }
    
    func test_list_jog_item_with_range() {
        
        // Given events and ranges
        mockAuthManager?.authType = AuthType.administrator
        
        let data: Data = StubHelper().loadJSONResource(name: "jogEvent")
        let decoder = JSONDecoder()
        let events = try! decoder.decode([JogEvent].self, from: data)
        
        let toDate = events.first!.date
        let fromDate = Calendar.current.date(byAdding: .hour, value: -2, to: toDate)!
        
        sut!.fromDate = fromDate
        sut!.toDate = toDate
        
        //When udpate events
        sut!.updateEvents(events)
        
        
        let numberOfEventInRange = events.filter { $0.date <= toDate && $0.date >= fromDate }.count
        
        XCTAssertEqual(sut!.displayItems.count, numberOfEventInRange)
        
    }
    
    func test_click_jog_detail() {
        
    }
    
    func test_filter_with_date() {
        
    }
    
    func test_trigger_general_fetch_when_view_appear() {
        
        //Given a general user
        mockAuthManager!.authType = AuthType.general
        
        //When viewWillAppear
        sut!.viewWillAppear()
        
        //trigger fetch jog events
        XCTAssertTrue( mockAPI!.isGeneralFetchCalled )
        
    }
    
    func test_trigger_manager_fetch_when_view_appear() {
        
        //Given a general user
        mockAuthManager!.authType = AuthType.manager
        
        //When viewWillAppear
        sut!.viewWillAppear()
        
        //trigger fetch jog events
        XCTAssertTrue( mockAPI!.isManagerFetchCalled )

    }
    
    func test_trigger_administrator_fetch_when_view_appear() {
        //Given a general user
        mockAuthManager!.authType = AuthType.administrator
        
        //When viewWillAppear
        sut!.viewWillAppear()
        
        //trigger fetch jog events
        XCTAssertTrue( mockAPI!.isAdministratorCalled )
    }
    
    
    func test_reload_view_after_data_fetched() {
        // given events
        let events = [ JogEvent ]()
        
        // When events fetched
        sut!.updateEvents(events)
        
        // Should trigger reload on view controller
        XCTAssertTrue( mockJogEventsViewCtontroller!.isReloadGetCalled )
    }

}

class MockAPIService: APIServiceProtocol {
    var isGeneralFetchCalled = false
    var isManagerFetchCalled = false
    var isAdministratorCalled = false
    
    func fetchJogEvent(authType: AuthType, complete: @escaping (Bool, [JogEvent], APIError?) -> ()) {
        switch authType {
        case .general:
            isGeneralFetchCalled = true
        case .manager:
            isManagerFetchCalled = true
        case .administrator:
            isAdministratorCalled = true
        }
    }
    
}

class MockJogEventsViewController: JogEventsViewControllerProtocol {
    var isReloadGetCalled = false
    func reloadTableView() {
        isReloadGetCalled = true
    }
}





