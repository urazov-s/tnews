//
//  NewsTitleMapper.swift
//  tnews
//
//  Created by Sergey Urazov on 08/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData

class NewsTitleMapper: Mapper {
    
    typealias PlainType = NewsTitle
    typealias ManagedType = MNewsTitle
    typealias PKType = Int64
    
    func map(dictionary: [String : Any]) throws -> PlainType {
        let milliseconds = try retrieveDate(fromDict: dictionary)
        
        return NewsTitle(id: try retrieveID(fromDict: dictionary),
                         text: try cast(dictionary["text"]),
                    publicationDate: Date(timeIntervalSince1970: milliseconds))
    }
    
    func map(managedObject: ManagedType) -> PlainType {
        return PlainType(id: managedObject.id,
                         text: managedObject.text ?? "",
                         publicationDate: Date(timeIntervalSince1970: managedObject.publicationDate))
    }
    
    func map(dictionary: [String : Any], intoObject object: ManagedType) throws {
        object.id = try retrieveID(fromDict: dictionary)
        object.name = try cast(dictionary["name"])
        object.text = try cast(dictionary["text"])
        object.publicationDate = try retrieveDate(fromDict: dictionary)
        object.bankInfoTypeId = try cast(dictionary["bankInfoTypeId"])
    }
    
    func retrievePKValue(fromDict dict: [String : Any]) throws -> Int64? {
        return try retrieveID(fromDict: dict)
    }
    
    // MARK:- Private
    
    private func retrieveID(fromDict dict: [String: Any]) throws -> Int64 {
        let idStr: String = try cast(dict["id"])
        guard let id = Int64(idStr) else {
            throw CastingError.invalidCasting
        }
        return id
    }
    
    private func retrieveDate(fromDict dict: [String: Any]) throws -> TimeInterval {
        let publicationDate: [String: Any] = try cast(dict["publicationDate"])
        let milliseconds: TimeInterval = try cast(publicationDate["milliseconds"])
        return milliseconds
    }
    
}
