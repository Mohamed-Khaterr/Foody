//
//  Order+CoreDataProperties.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var date: Date?
    @NSManaged public var mealId: String?
    @NSManaged public var mealImage: String?
    @NSManaged public var mealName: String?
    @NSManaged public var userName: String?
    @NSManaged public var quantity: Int64

}

extension Order : Identifiable {

}
