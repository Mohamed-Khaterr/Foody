//
//  Order+CoreDataClass.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    // For Dependency Injection
    struct Dependency {
        let mealId: String
        let mealName: String
        let mealImage: String?
        let date: Date
        let userName: String
        let quantity: Int
    }
}
