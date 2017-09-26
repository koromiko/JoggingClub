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
    var mockAuth: MockAuthManager?
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
    
    func test_state_change_loading() {
        // When state change to loading
        self.sut!.isLoading = true
        
        XCTAssertEqual( self.mockViewController!.isLoadingViewHidden, false)
        XCTAssertEqual( self.mockViewController!.isSubmitButtonClicable, false)
    }
    
    func test_state_change_login() {
        // Given a sut
        
        // When change to login state
        self.sut!.state = AccountViewState.login
        
        // Assert title
        XCTAssertEqual(self.mockViewController!.pageTitle, "Login" )
        
        // Assert submit button title
        XCTAssertEqual(self.mockViewController!.submitButtonTitle, "Login" )
        
    }

    func test_state_change_signup() {
        // Given a sut
        
        // When change to login state
        self.sut!.state = AccountViewState.signup
        
        // Assert title
        XCTAssertEqual(self.mockViewController!.pageTitle, "Signup" )
        
        // Assert submit button title
        XCTAssertEqual(self.mockViewController!.submitButtonTitle, "Signup" )
    }
    
    func test_state_change_loaging() {
        
    }
    
    func test_user_switch_to_signup() {
        // Given a view model
        // When user click signup btn
        self.sut!.userClickSignUpButton()
        
        // State should be signup
        XCTAssertEqual( self.sut!.state, AccountViewState.signup )

    }
    
    func test_user_switch_to_login() {
        // Given a view model
        // When user click signup btn
        self.sut!.userClickLoginButton()
        
        // State should be signup
        XCTAssertEqual( self.sut!.state, AccountViewState.login )
    }
    
    func test_user_click_login_submit() {
        
        // Given a login state
        self.sut!.state = AccountViewState.login
        self.sut!.email = "account"
        self.sut!.password = "password"
        
        // When submit click
        self.sut!.userClickSubmit()
        
        
        // Login should get called
        XCTAssertTrue( self.mockAuth!.isLoginGetCalled )
        
        // Should show loading view
        XCTAssertFalse( self.mockViewController!.isLoadingViewHidden )
        
        // User name/password passed to auth
        XCTAssertEqual( self.mockAuth!.submittedEmail, self.sut!.email )
        XCTAssertEqual( self.mockAuth!.submittedPassword, self.sut!.password )
        
    }
    
    func test_user_click_signup_submit() {
        
        // Given a signup state
        self.sut!.state = AccountViewState.signup
        self.sut!.email = "account"
        self.sut!.password = "password"
        
        // When submit click
        self.sut!.userClickSubmit()
        
        // Login should get called
        XCTAssertTrue( self.mockAuth!.isSignUpCalled )
        
        // Should show loading view
        XCTAssertFalse( self.mockViewController!.isLoadingViewHidden )
        
        // User name/password passed to auth
        XCTAssertEqual( self.mockAuth!.submittedEmail, self.sut!.email )
        XCTAssertEqual( self.mockAuth!.submittedPassword, self.sut!.password )
        
    }
    
    func test_login_complete() {
        //Given a sut with login state
        sut!.state = AccountViewState.login
        
        //When login complete
        sut!.loginComplete()
        
        //Assert dismiss
        XCTAssertTrue( mockViewController!.isDismissedCalled )
        
    }
    
    func test_signup_complete(){
        
    }
    
}

class MockAccountViewController: AccountViewControllerDelegate {
    
    
    var isDismissedCalled = false
    var pageTitle: String = ""
    var submitButtonTitle: String = ""
    var isLoadingViewHidden: Bool = false
    var isSubmitButtonClicable: Bool = true
    
    func setTitle(title: String) {
        pageTitle = title
    }
    
    func setSubmitButtonTitle(title: String) {
        submitButtonTitle = title
    }
    
    func setLoading(isLoading: Bool) {
        isLoadingViewHidden = !isLoading
    }
    
    func setButtonEnabled(isEnabled: Bool) {
        self.isSubmitButtonClicable = isEnabled
    }
    
    func dismiss() {
        isDismissedCalled = true
    }
}

class MockAuthManager: AuthManagerProtocol {
    
    var isLoggedIn: Bool = false
    
    var isLoginGetCalled: Bool = false
    var isSignUpCalled: Bool = false
    var submittedEmail: String?
    var submittedPassword: String?
    
    func sighUp(email: String, password: String, complete: @escaping (Bool, AuthError?) -> ()) {
        isSignUpCalled = true
        submittedEmail = email
        submittedPassword = password
    }
    
    func logIn(email: String, password: String, complete: @escaping (Bool, AuthError?) -> ()) {
        isLoginGetCalled = true
        submittedEmail = email
        submittedPassword = password
    }
    
    func logout() {
        
    }
}
