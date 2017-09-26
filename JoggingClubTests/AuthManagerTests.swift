//
//  AuthManagerTests.swift
//  JoggingClubTests
//
//  Created by Neo on 25/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
import Firebase
@testable import JoggingClub

class AuthManagerTests: XCTestCase {
    
    var sut: AuthManager?
    var mockAuth: MockAuth?
    
    override func setUp() {
        super.setUp()
        self.mockAuth = MockAuth()
        self.sut = AuthManager(auth: mockAuth!)
        
    }
    
    override func tearDown() {
        self.mockAuth = nil
        self.sut = nil
        super.tearDown()
    }
    
    func test_user_can_sign_up() {
        
        // Given a general member
        let email = "neo@abc.com"
        let password = "123456"
        
        // When sign up
        
        let expect = XCTestExpectation(description: "Call back was calledd")
        
        sut!.sighUp( email: email, password: password ) { (success: Bool, error: AuthError? ) in
            expect.fulfill()
        }
        
        // Assert: Manager call creation to Auth
        XCTAssertTrue( self.mockAuth!.isCreateUserCalled )
        
        // Assert: Call back get called
        wait(for: [expect], timeout: 0.5)
        
    }
    
    func test_login_success() {
        //Given correct email & password
        let email = "neo@abc.edf"
        let password = "123456"
        
        // When login
        
        let expect = XCTestExpectation(description: "Login callback should get called ")
        
        sut!.logIn(email: email, password: password, complete: { (success, error) in
            expect.fulfill()
        })
        
        // Assert: Login to firebase should called
        XCTAssertTrue( mockAuth!.isLoginCalled )
        
        // Assert: Call back should be called
        wait(for: [expect], timeout: 0.5)

    }
    
    
    func test_user_logout() {
        // Given a sut
        // When logout
        sut!.logout()
        
        // Assert: firebase logout get called
        XCTAssertTrue(mockAuth!.isLogoutCalled)
    }
    
    
    
    
    
}

class MockAuth: FirebaseAuthProtocol {
    var isCreateUserCalled: Bool = false
    var isLoginCalled = false
    var isLogoutCalled = false
    
    func createUser(withEmail email: String, password: String, completion: AuthResultCallback?) {
        isCreateUserCalled = true
        completion!(nil,nil)
    }
    
    func signIn(withEmail email: String, password: String, completion: AuthResultCallback?) {
        isLoginCalled = true
        completion!(nil, nil)
    }
    
    func signOut() throws {
        isLogoutCalled = true
    }
    
}


