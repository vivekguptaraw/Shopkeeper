//
//  Product+CoreDataProperties.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var ordersCount: Int64
    @NSManaged public var shareCount: Int64
    @NSManaged public var viewsCount: Int64
    @NSManaged public var category: Category?
    @NSManaged public var ranking: NSSet?
    @NSManaged public var tax: Tax?
    @NSManaged public var variants: NSSet?

}

// MARK: Generated accessors for ranking
extension Product {

    @objc(addRankingObject:)
    @NSManaged public func addToRanking(_ value: Ranking)

    @objc(removeRankingObject:)
    @NSManaged public func removeFromRanking(_ value: Ranking)

    @objc(addRanking:)
    @NSManaged public func addToRanking(_ values: NSSet)

    @objc(removeRanking:)
    @NSManaged public func removeFromRanking(_ values: NSSet)

}

// MARK: Generated accessors for variants
extension Product {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: Variants)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: Variants)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}
