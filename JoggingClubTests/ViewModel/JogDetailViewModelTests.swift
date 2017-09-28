//
//  JogDetailViewModel.swift
//  JoggingClubTests
//
//  Created by Neo on 27/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
@testable import JoggingClub

class JogDetailViewModelTests: XCTestCase {
    
    var sut: JogDetailViewModel?
    var mockDetailViewController: MockJogDetailViewController?
    var mockAPI: MockAPIService?
    var mockAuthManager: MockAuthManager?
    
    override func setUp() {
        super.setUp()
        mockAPI = MockAPIService()
        mockAuthManager = MockAuthManager()
        mockDetailViewController = MockJogDetailViewController()
        sut = JogDetailViewModel( api: mockAPI!,
                                  authManager: mockAuthManager!,
                                  mode: .add )
        sut!.delegate = mockDetailViewController
    }
    
    override func tearDown() {
        sut = nil
        mockAPI = nil
        mockAuthManager = nil
        mockDetailViewController = nil
        super.tearDown()
    }
    
    func test_display_empty_when_insert_mode() {
       
        // Given a insert view model, with logged in user
        sut!.mode = .add
        mockAuthManager!.uid = "1"
        mockAuthManager!.account = "asdf@wer.asdf"
        mockAuthManager!.authType = .general
        
        // When view is ready
        sut!.viewIsReady()
        
        // Assert: The value should be empty
        XCTAssertNotNil(sut!.displayItem)

    }
    
    func test_displayitem_when_edit_mode() {
        
        // Given sut with edit mode
        sut!.mode = .edit
        sut!.event = StubHelper().loadEvent()
        
        // When view did load
        sut!.viewIsReady()
        
        // View is updated
        XCTAssert(mockDetailViewController!.isUpdateViewCalled)
        
        // display item not nil
        XCTAssertNotNil(sut!.displayItem)
    }
    
    func test_user_click_done_button_error_when_data_not_valid_add() {
        // Give sut with insert mode
        sut!.mode = .add
        
        // When done button click
        sut!.userClickDone(inputDistance: "", inputDuration: "", inputDate: Date())
        
        // Asser api add called with correct parameter
        XCTAssertFalse(mockAPI!.isAddCalled)
        XCTAssert(mockDetailViewController!.isErrorDisplayed)

    }
    
    func test_user_click_done_button_error_when_data_not_valid_edit() {
        // Give sut with insert mode
        sut!.mode = .edit
        
        // When done button click
        sut!.userClickDone(inputDistance: "", inputDuration: "", inputDate: Date())
        
        // Asser api add called with correct parameter
        XCTAssertFalse(mockAPI!.isAddCalled)
        XCTAssert(mockDetailViewController!.isErrorDisplayed)
        
    }
    
    func test_user_click_done_button_add_correct_data() {
        // Given add mode
        sut!.mode = .add
        mockAuthManager!.uid = "1"
        mockAuthManager!.account = "qwer@asdf.adsf"
        mockAuthManager!.authType = .general
        
        let inputDate = Date(timeIntervalSinceNow: TimeInterval(exactly: -3600)! )
        
        // When done button click
        sut!.userClickDone(inputDistance: "3000", inputDuration: "300", inputDate: inputDate)

        // Asser api add called with correct parameter
        XCTAssert(mockAPI!.isAddCalled)
        XCTAssertEqual(mockAPI!.submittedEvent!.duration, 300)
        XCTAssertEqual(mockAPI!.submittedEvent!.distance, 3000.0)
        XCTAssertEqual(mockAPI!.submittedEvent!.user.id, mockAuthManager!.uid)
        XCTAssertEqual(mockAPI!.submittedEvent!.user.authType, mockAuthManager!.authType.rawValue)
        XCTAssertEqual(mockAPI!.submittedEvent!.user.account, mockAuthManager!.account)
        
    }
    
    func test_user_click_done_button_edit() {
        // Give sut with edit mode
        sut!.mode = .edit
        let event = StubHelper().loadEvent()
        sut!.event = event
        
        // When done button click
        sut!.userClickDone(inputDistance: "12345", inputDuration: "123", inputDate: event.date)
        
        // Asser api add called with correct parameter
        XCTAssert(mockAPI!.isEditCalled)
        XCTAssertEqual(mockAPI!.submittedEvent!.id!, event.id!)
        XCTAssertEqual(mockAPI!.submittedEvent!.distance, 12345.0)
        XCTAssertEqual(mockAPI!.submittedEvent!.duration, 123)
        
        //Show loading
        XCTAssertTrue(mockDetailViewController!.isLoading)

    }
    
    func test_input_limitation() {
        
    }

}

class MockJogDetailViewController: UIViewController, JogDetailViewControllerProtocol {
    var isUpdateViewCalled: Bool = false
    var isErrorDisplayed: Bool = false
    
    var isLoading: Bool = false
    var isLeaveCalled: Bool = false
    
    func updateView() {
        isUpdateViewCalled = true
    }
    
    func showError(message: String) {
        isErrorDisplayed = true
    }
    
    func leave() {
        isLeaveCalled = true
    }
    
    func updateLoadingState(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
}
