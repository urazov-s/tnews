//
//  NSManagedObject+PKRequest.swift
//  tnews
//
//  Created by Sergey Urazov on 12/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    static func pkRequest<M: NSManagedObject, V>(withValue value: V) -> NSFetchRequest<M>? {
        if let pk = M.entity().userInfo?["pk"] {
            let request = NSFetchRequest<M>(entityName: M.entity().name!)
            request.predicate = NSPredicate(format: "\(pk) = \(value)")
            return request
        }
        return nil
    }
    
}
