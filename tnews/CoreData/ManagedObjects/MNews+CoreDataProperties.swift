//
//  MNews+CoreDataProperties.swift
//  tnews
//
//  Created by Sergey Urazov on 11/06/2017.
//  Copyright © 2017 Sergey Urazov. All rights reserved.
//

import Foundation
import CoreData


extension MNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MNews> {
        return NSFetchRequest<MNews>(entityName: "News");
    }

    @NSManaged public var content: String?
    @NSManaged public var title: MNewsTitle?

}
