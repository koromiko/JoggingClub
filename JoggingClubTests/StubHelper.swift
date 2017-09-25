//
//  StubHelper.swift
//  JoggingClubTests
//
//  Created by Neo on 24/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
import CoreData

class StubHelper<T> {
    let container: NSPersistentContainer
    var entityName: String
    
    init( container: NSPersistentContainer, entityName: String) {
        self.container = container
        self.entityName = entityName
        
    }
    
    func initStubs( stubs: [[String: Any]] ) {
        func insertData( param: [String: Any] ) {
            let obj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: container.viewContext)
            for key in param.keys {
                obj.setValue(param[key], forKey: key)
            }
        }
        
        for item in stubs {
            insertData(param: item)
        }
        do {
            try container.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }
    
    func selectFirstStub() -> T? {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let objs = try! container.viewContext.fetch(fetchRequest)
        return objs.first as? T
    }
    
    func flushStubData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let objs = try! container.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            container.viewContext.delete(obj)
        }
        try! container.viewContext.save()
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let results = try! container.viewContext.fetch(request)
        return results.count
    }
}


