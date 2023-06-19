//
//  OrderListViewModel.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import Foundation


class OrderListViewModel {
    
    // MARK: - Private Variables
    private let orderManager = OrderManager()
    
    private var orders = [Order]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    
    // MARK: - Public Variables
    public var reloadData: (() -> Void)?
    
    public var numberOfRows: Int {
        return orders.isEmpty ? 1 : orders.count
    }
    
    public var showNoOrdersMessage: Bool {
        return orders.isEmpty
    }
    
    
    
    // MARK: - Methods
    public func viewDidLoad() {
        orders = orderManager.fetchOrders()
    }
    
    public func rowAt(_ indexPath: IndexPath) -> Order? {
        return orders.isEmpty ? nil : orders[indexPath.row]
    }
    
    public func didSelectRowAt(_ indexPath: IndexPath, completionHandler: @escaping (MealDetailsViewController) -> Void) {
        if orders.isEmpty { return }
        let order = orders[indexPath.row]
        guard let mealId = order.mealId else { return }
        let mealDetailsVC = MealDetailsViewController(mealID: mealId, showPlaceOrderButton: false)
        DispatchQueue.main.async {
            completionHandler(mealDetailsVC)
        }
    }
}
