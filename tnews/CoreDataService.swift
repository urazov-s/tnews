//
//  CoreDataService.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataService {
    
    var context: NSManagedObjectContext { get }
    
    func usingContext<T>(context: NSManagedObjectContext, withCompletion completion: @escaping (T?, ServiceError?)->(), do: @escaping () throws ->())
    
}

extension CoreDataService {
    
    var context: NSManagedObjectContext {
        return CoreDataProvider.shared.backgroundContext
    }
    
    func usingContext<T>(context: NSManagedObjectContext, withCompletion completion: @escaping (T?, ServiceError?)->(), do: @escaping () throws ->()) {
        context.perform {
            do {
                try `do`()
            } catch CastingError.invalidCasting {
                completion(nil, .unexpectedResponse)
            } catch {
                completion(nil, .undefined)
            }
        }
    }
    
}
