//
//  StorageService.swift
//  JoggingClub
//
//  Created by Neo on 24/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StorageService {
    
    let persistentContainer: NSPersistentContainer!
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
}

class UserStorageService: StorageService {
    //MARK: User CRUD
    func addUser(_ name: String, _ rule: UserRule ) -> UserEntity? {
        if let obj = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: backgroundContext) as? UserEntity {
            obj.name = name
            obj.rule = Int16(rule.rawValue)
            return obj
        }else {
            return nil
        }
    }
    
    func removeUser( objID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objID)
        backgroundContext.delete(obj)
    }
    
    func editUser( objID: NSManagedObjectID, name: String?, rule: UserRule? ) {
        if let obj = backgroundContext.object(with: objID) as? UserEntity {
            if name != nil {
                obj.name = name
            }
            if let rule = rule {
                obj.rule = Int16(rule.rawValue)
            }
        }
    }
    
    func fetchAllUser() -> [UserEntity] {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        let objs = try? persistentContainer.viewContext.fetch(fetchRequest)
        if let objs = objs as? [UserEntity] {
            return objs
        }else {
            return [UserEntity]()
        }
    }
}

class JogEventStorageService: StorageService {
    
    //MARK: CRUD
    func addJogEvent( date: Date, duration: Int, distance: Float, user: UserEntity? ) -> JogEventEntify? {
        
        if let obj = NSEntityDescription.insertNewObject(forEntityName: "JogEventEntify", into: backgroundContext) as? JogEventEntify {
            obj.date = date
            obj.duration = Int64(duration)
            obj.distance = distance
            obj.user = user
            return obj
        }else {
            return nil
        }
    }
    
    func removeJogEvent( objID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objID)
        backgroundContext.delete(obj)
    }
    
    func editJogEvent( objID: NSManagedObjectID, date: Date?, duration: Int?, distance: Float?, user: UserEntity? ) {
        if let obj = backgroundContext.object(with: objID) as? JogEventEntify {
            if let date = date {
                obj.date = date
            }
            if let duration = duration {
                obj.duration = Int64(duration)
            }
            if let distance = distance {
                obj.distance = distance
            }
            if user != nil {
                obj.user = user
            }
        }
    }
    
    func fetchAllJogEvents() -> [JogEventEntify] {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "JogEventEntify")
        let objs = try? persistentContainer.viewContext.fetch(fetchRequest)
        if let objs = objs as? [JogEventEntify] {
            return objs
        }else {
            return [JogEventEntify]()
        }
    }
}



