//
//  MNewsTitle+CoreDataProperties.swift
//  tnews
//
//  Created by Sergey Urazov on 11/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData


extension MNewsTitle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MNewsTitle> {
        return NSFetchRequest<MNewsTitle>(entityName: "NewsTitle");
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var text: String?
    @NSManaged public var publicationDate: TimeInterval
    @NSManaged public var bankInfoTypeId: Int16
    @NSManaged public var news: MNews?

}
