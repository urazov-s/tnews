//
//  CoreDataProvider.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataProvider {
    
    static let shared: CoreDataProvider = CoreDataProvider()
    
    private init() { }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context =  NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    // MARK:- Stack
    
    private lazy var documentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "tnews", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.documentsDirectory.appendingPathComponent("data.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            NSLog("Unable to add persistent store")
        }
        
        return coordinator
    }()
    
}
