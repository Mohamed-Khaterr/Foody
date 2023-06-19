//
//  CreateOrderViewModel.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import Foundation


class CreateOrderViewModel {
    
    // MARK: - Public Variables
    public var updateQuantity: ((String)->Void)?
    public var showLoadingView: ((Bool)->Void)?
    public var orderStatus: ((Bool)->Void)?
    
    
    // MARK: - Private Variables
    private let mealDetails: MealDetails
    private var quantity: Int = 0 {
        didSet {
            let quantityString = String(quantity)
            updateQuantity?(quantityString)
        }
    }
    
    
    
    // MARK: - init
    init(mealDetails: MealDetails) {
        self.mealDetails = mealDetails
        quantity = 1
    }
    
    
    // MARK: - Methods
    public func increaseQuantity() {
        quantity += 1
    }
    
    public func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    public func createOrder(userName: String) {
        showLoadingView?(true)
        guard !userName.isEmpty else {
            orderStatus?(false)
            showLoadingView?(false)
            return
        }
        let orederManager = OrderManager()
        orederManager.createOrder(.init(mealId: mealDetails.id, mealName: mealDetails.name, mealImage: mealDetails.image, date: Date(), userName: userName, quantity: quantity))
        showLoadingView?(false)
        orderStatus?(true)
    }
}
