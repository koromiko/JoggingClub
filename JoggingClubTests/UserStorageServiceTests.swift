//
//  StorageServiceTests.swift
//  JoggingClubTests
//
//  Created by Neo on 24/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
import CoreData
@testable import JoggingClub

class UserStorageServiceTests: XCTestCase {
    
    var sut: UserStorageService?
    lazy var stubsHelper: StorageStubHelper = {
        return StorageStubHelper<JoggingClub.UserEntity>(container: self.mockPersistantContainer, entityName: "UserEntity")
    }()
    
    override func setUp() {
        super.setUp()
        sut = UserStorageService(container: mockPersistantContainer)
        stubsHelper.initStubs(stubs: [
            [ "name": "u1", "rule": AuthType.general.rawValue ],
            [ "name": "u2", "rule": AuthType.administrator.rawValue ],
            [ "name": "u3", "rule": AuthType.manager.rawValue ],
            [ "name": "u4", "rule": AuthType.general.rawValue ],
            [ "name": "u5", "rule": AuthType.general.rawValue ]
            ])
    }
    
    override func tearDown() {
        sut = nil
        stubsHelper.flushStubData()
        super.tearDown()
    }
    
    
    //MARK: test User CRUD
    func testAddUser() {
        
        // Give a user name & rule
        let username = "first_user@gmail.com"
        let rule = AuthType.general
        
        let numberOfUsersBeforeInsert = stubsHelper.numberOfItemsInPersistentStore()
        
        // Whe add user to database
        _ = sut!.addUser( username, rule )
        sut!.save()
        
        // The number of users sould +1
        XCTAssertEqual(numberOfUsersBeforeInsert+1, stubsHelper.numberOfItemsInPersistentStore() )
        
    }
    
    func testRemoveAUser(){
        
        // Given a user in database
        let numberOfUsersBeforeRemove = stubsHelper.numberOfItemsInPersistentStore()
        let aUser = stubsHelper.selectFirstStub()!
        
        // When remove one
        sut!.removeUser( objID: aUser.objectID)
        sut!.save()
        
        // The number should be substracted by 1
        XCTAssertEqual(numberOfUsersBeforeRemove-1, stubsHelper.numberOfItemsInPersistentStore() )
   
    }
    
    func testEditAUser() {
        
        // Given a user in database
        let aUser = stubsHelper.selectFirstStub()!
        
        //When edit user name
        let newName = "chaned user"
        sut!.editUser( objID: aUser.objectID, name: newName, rule: nil )
        sut!.save()
        
        //the new user name should equal to input
        let comparUser = stubsHelper.selectFirstStub()!
        XCTAssertEqual(comparUser.name, newName )
        
        //should not remove the origin value if param is nil
        XCTAssertNotNil(comparUser.rule)
        
    }
    
    func testFetchUsers() {
        
        // Given a stub database
        
        // When fetch all
        let allUsers = sut!.fetchAllUser()
        
        // Assert the results number should be equaal to the number in db
        XCTAssertEqual(allUsers.count, 5)
    }
    
    

    //MARK: mock in-memory persistant store
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "JoggingClub", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

}
