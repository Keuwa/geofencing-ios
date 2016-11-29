//
//  DataManager.swift
//  TeamOrganizer
//
//  Created by Vincent Durpoix on 16/11/2016.
//  Copyright © 2016 keuwa. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    public static let shared = DataManager()
    public var objectContext: NSManagedObjectContext?
    
    private override init(){
        if let modelUrl = Bundle.main.url(forResource: "TeamOrganizer", withExtension: "momd"){
            if let model = NSManagedObjectModel(contentsOf: modelUrl){
                let persis = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                _ = try? persis.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: FileManager.documentURL(childPath: "teamorganizer.db"), options: nil)
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                context.persistentStoreCoordinator = persis
                self.objectContext = context
            }
        }
    }
}
