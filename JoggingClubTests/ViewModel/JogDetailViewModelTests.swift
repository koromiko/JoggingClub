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
    
    override func setUp() {
        super.setUp()
        mockAPI = MockAPIService()
        mockDetailViewController = MockJogDetailViewController()
        sut = JogDetailViewModel(api: mockAPI!, event: StubHelper().loadEvent(), mode: .add)
        sut!.delegate = mockDetailViewController
    }
    
    override func tearDown() {
        sut = nil
        mockAPI = nil
        mockDetailViewController = nil
        super.tearDown()
    }
    
    func test_display_empty_when_insert_mode() {
       
        
    }
    
    func test_displayitem_when_edit_mode() {
        
        // Given sut with edit mode
        sut!.mode = .edit
        
        // When view did load
        sut!.viewIsReady()
        
        // View is updated
        XCTAssert(mockDetailViewController!.isUpdateViewCalled)
        
        // display item not nil
        XCTAssertNotNil(sut!.displayItem)
    }
    
    func test_user_click_done_button_insert() {
        // Give sut with insert mode
        sut!.mode = .add
        
        // When done button click
        sut!.userClickDone()
        
        // Asser api add called with correct parameter
        
        
    }
    
    func test_user_click_done_button_edit() {
        // given sut with edit mode
        // When done button click
    
    }
    
    func test_input_limitation() {
        
    }

}

class MockJogDetailViewController: UIViewController, JogDetailViewControllerProtocol {
    var isUpdateViewCalled: Bool = false
    
    func updateView() {
        isUpdateViewCalled = true
    }
}
