//
//  AccountViewModelTests.swift
//  JoggingClubTests
//
//  Created by Neo on 26/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
@testable import JoggingClub

class AccountViewModelTests: XCTestCase {
    
    var sut: AccountViewModel?
    var mockAuth: AuthManagerProtocol?
    var mockViewController: MockAccountViewController?
    
    override func setUp() {
        super.setUp()
        mockAuth = MockAuthManager()
        mockViewController = MockAccountViewController()
        sut = AccountViewModel( auth: mockAuth!, delegate: mockViewController! )
    }
    
    override func tearDown() {
        sut = nil
        mockAuth = nil
        mockViewController = nil
        super.tearDown()
    }
    
    func test_dismiss_when_user_loggedIn() {
        // Given a auth with logged in user
        mockAuth!.isLoggedIn = true
        
        // When view init
        sut!.viewIsReady()
        
        // Assert dismiss get called
        XCTAssertTrue( self.mockViewController!.isDismissedCalled )

    }
    
    
}

class MockAccountViewController: AccountViewControllerDelegate {
    var isDismissedCalled = false
    func dismiss() {
        isDismissedCalled = true
    }
}

class MockAuthManager: AuthManagerProtocol {
    
    var isLoggedIn: Bool = false
    
    func sighUp(email: String, password: String, complete: @escaping (Bool, String?, AuthError?) -> ()) {
        
    }
    func logIn(email: String, password: String, complete: @escaping (Bool, String?, AuthError?) -> ()) {
        
    }
    func logout() {
        
    }
}
