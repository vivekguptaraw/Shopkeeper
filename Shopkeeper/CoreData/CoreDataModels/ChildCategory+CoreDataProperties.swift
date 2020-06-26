//
//  ChildCategory+CoreDataProperties.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension ChildCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChildCategory> {
        return NSFetchRequest<ChildCategory>(entityName: "ChildCategory")
    }

    @NSManaged public var id: Int16
    @NSManaged public var category: Category?

}
