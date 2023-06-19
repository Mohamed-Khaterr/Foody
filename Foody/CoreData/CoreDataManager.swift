//
//  CoreDataManager.swift
//  Foody
//
//  Created by Khater on 6/10/23.
//

import Foundation
import CoreData


class CoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Foody")
        container.loadPersistentStores(completionHandler: { description, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()


    func saveChanges() {
        // Save changes on managed object context
        if context.hasChanges {
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Error: \(error), \(error.userInfo)")
            }
        }
    }
}
