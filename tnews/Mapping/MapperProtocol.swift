//
//  MapperProtocol.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData

protocol Mapper {
    
    associatedtype PlainType
    associatedtype ManagedType: NSManagedObject
    associatedtype PKType
    
    @discardableResult func parse(dictionary: [String : Any], inContext context: NSManagedObjectContext) throws -> ManagedType
    func map(dictionary: [String: Any]) throws -> PlainType
    func map(dictionary: [String: Any], intoObject object: ManagedType) throws
    func map(managedObject: ManagedType) -> PlainType
    
    func retrievePKValue(fromDict dict: [String: Any]) throws -> PKType?
    
}

extension Mapper {
    
    @discardableResult func parse(dictionary: [String : Any], inContext context: NSManagedObjectContext) throws -> ManagedType {
        var item: ManagedType!
        if let pkValue: PKType = try retrievePKValue(fromDict: dictionary),
            let pkRequest: NSFetchRequest<ManagedType> = ManagedType.pkRequest(withValue: pkValue) {
            if let existing = try context.fetch(pkRequest).first {
                item = existing
            }
        }
        
        if item == nil {
            item = NSEntityDescription.insertNewObject(forEntityName: ManagedType.entity().name!, into: context) as! ManagedType
        }
        
        try map(dictionary: dictionary, intoObject: item)
        return item
    }
    
    func retrievePKValue(fromDict dict: [String: Any]) -> PKType? {
        return nil
    }
    
}
