//
//  JogEventStorageService.swift
//  JoggingClub
//
//  Created by Neo on 24/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
import CoreData

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
