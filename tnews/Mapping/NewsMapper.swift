//
//  NewsMapper.swift
//  tnews
//
//  Created by Sergey Urazov on 12/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation

class NewsMapper: Mapper {
    
    typealias PlainType = News
    typealias ManagedType = MNews
    typealias PKType = Int64
    
    private let titleMapper = NewsTitleMapper()
    
    func map(managedObject: ManagedType) -> PlainType {
        return PlainType(content: managedObject.content)
    }
    
    func map(dictionary: [String : Any]) throws -> PlainType {
        return PlainType(content: try cast(dictionary["content"]))
    }
    
    func map(dictionary: [String : Any], intoObject object: ManagedType) throws {
        object.content = try cast(dictionary["content"])
        object.title = try titleMapper.parse(dictionary: cast(dictionary["title"]), inContext: object.managedObjectContext!)
    }
    
    func retrievePKValue(fromDict dict: [String : Any]) throws -> Int64? {
        return try titleMapper.retrievePKValue(fromDict: try cast(dict["title"]))
    }
    
}
