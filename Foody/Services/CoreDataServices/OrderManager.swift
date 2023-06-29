//
//  OrderManager.swift
//  Foody
//
//  Created by Khater on 6/10/23.
//

import Foundation


protocol OrderManagerType {
    func createOrder(_ data: Order.Dependency)
    func fetchOrders() -> [Order]
    func deleteOrder(_ order: Order)
}


final class OrderManager: CoreDataManager, OrderManagerType {
    
    func createOrder(_ data: Order.Dependency) {
        // Create new Order
        let order = Order(context: super.context)
        order.mealId = data.mealId
        order.mealName = data.mealName
        order.mealImage = data.mealImage
        order.date = data.date
        order.userName = data.userName
        order.quantity = Int64(data.quantity)
            
        super.saveChanges()
    }
    
    func fetchOrders() -> [Order] {
        do {
            // Fetching all order
            let orders = try super.context.fetch(Order.fetchRequest())
            return orders
            
        } catch {
            print("Error fetching: \(error)")
        }
        
        return []
    }
    
    func deleteOrder(_ order: Order) {
        // Delete Order
        super.context.delete(order)
        super.saveChanges()
    }
}
