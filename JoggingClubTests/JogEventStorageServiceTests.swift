//
//  JogEventStorageServiceTests.swift
//  JoggingClubTests
//
//  Created by Neo on 24/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
import CoreData
@testable import JoggingClub

class JogEventStorageServiceTests: XCTestCase {
    
    var sut: JogEventStorageService?
    lazy var stubHelper: StubHelper = {
        return StubHelper<JoggingClub.JogEventEntify>(container: self.mockPersistantContainer, entityName: "JogEventEntify")
    }()
    
    override func setUp() {
        super.setUp()
        
        sut = JogEventStorageService(container: mockPersistantContainer)
        stubHelper.initStubs(stubs: [
            ["date": Date(), "duration": 3600, "distance": 501],
            ["date": Date(), "duration": 1800, "distance": 502],
            ["date": Date(), "duration": 2000, "distance": 503],
            ["date": Date(), "duration": 2200, "distance": 504],
            ["date": Date(), "duration": 2500, "distance": 505]
            ])
        
    }
    
    override func tearDown() {
        stubHelper.flushStubData()
        super.tearDown()
    }
    
    func testAddJogEvent() {
        //Given a jog
        let numberOfEventBeforeAdd = stubHelper.numberOfItemsInPersistentStore()
        
        let date: Date = Date()
        let duration: Int = 1300
        let distanct: Float = 3000.0
        
        // When add a jog
        _ = sut?.addJogEvent(date: date, duration: duration, distance: distanct, user: nil)
        sut?.save()
        
        // The number of jog should + 1
        XCTAssertEqual( numberOfEventBeforeAdd + 1 , stubHelper.numberOfItemsInPersistentStore())
        
    }

    func testRemoveJogEvent() {
        // Given a jog event in database
        let numberOfEventsBeforeRemove = stubHelper.numberOfItemsInPersistentStore()
        let aEvent = stubHelper.selectFirstStub()!
        
        // When remove one
        sut!.removeJogEvent( objID: aEvent.objectID)
        sut!.save()
        
        // The number should be substracted by 1
        XCTAssertEqual(numberOfEventsBeforeRemove-1, stubHelper.numberOfItemsInPersistentStore() )
    }
    
    func testEditJogEvent() {
        
        // Given a user in database
        let aEvent = stubHelper.selectFirstStub()!
        
        //When edit user name
        let newDistance: Float = 3000.0
        sut?.editJogEvent(objID: aEvent.objectID, date: nil, duration: nil, distance: newDistance, user: nil)
        sut!.save()
        
        //the new user name should equal to input
        let compareEvent = stubHelper.selectFirstStub()!
        XCTAssertEqual(compareEvent.distance, newDistance )
        
        //should not remove the origin value if param is nil
        XCTAssertNotNil(compareEvent.duration)
        XCTAssertNotNil(compareEvent.date)
        
    }
    
    func testFetchAllJog() {
        // Given a stub database
        
        // When fetch all
        let alEvents = sut!.fetchAllJogEvents()
        
        // Assert the results number should be equaal to the number in db
        XCTAssertEqual(alEvents.count, 5)
    }

    //MARK: mock in-memory persistant store
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main] )!
        return managedObjectModel
    }()

    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "JoggingClub.JoggingClub", managedObjectModel: self.managedObjectModel)
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
