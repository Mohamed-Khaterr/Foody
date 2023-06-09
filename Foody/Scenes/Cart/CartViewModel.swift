//
//  CartViewModel.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import Foundation
import Combine


typealias CartInput = CartViewModel.Input
typealias CartOutput = CartViewModel.Output

final class CartViewModel {
    
    enum Input {
        case viewDidLoad
        case didSelectRowAt(_ indexPath: IndexPath)
    }
    
    enum Output {
        case reloadData
        case noOrdersMessage(isAppeare: Bool)
        case goToMealDetailsVC(_ vc: MealDetailsViewController)
    }
    
    
    // MARK: - Private Variables
    private let orderManager: OrderManagerType
    private let outputPublisher: PassthroughSubject<CartViewModel.Output, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    private var orders = [Order]()
    
    
    init(orderManager: OrderManagerType = OrderManager()) {
        self.orderManager = orderManager
    }
    
    deinit {
        print("deinit: CartViewModel")
    }
    
    public var numberOfRows: Int {
        return orders.count
    }
    
    public func rowForCell(at indexPath: IndexPath) -> Order {
        return orders[indexPath.row]
    }
    
    
    
    // MARK: - Methods
    public func bind(input subscription: AnyPublisher<CartInput, Never>) -> AnyPublisher<CartOutput, Never> {
        subscription
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                guard let self = self else { return }
                switch events {
                case .viewDidLoad:
                    self.fetchOrders()
                    let messageIsAppear = self.orders.isEmpty
                    self.outputPublisher.send(.noOrdersMessage(isAppeare: messageIsAppear))
                    self.outputPublisher.send(.reloadData)
                    
                case .didSelectRowAt(let indexPath):
                    let order = orders[indexPath.row]
                    guard let mealId = order.mealId else { return }
                    let mealDetailsVC = MealDetailsViewController(mealID: mealId, showPlaceOrderButton: false)
                    self.outputPublisher.send(.goToMealDetailsVC(mealDetailsVC))
                }
            }
            .store(in: &cancellable)
        
        return outputPublisher.eraseToAnyPublisher()
    }
    
    private func fetchOrders() {
        orders = orderManager.fetchOrders()
    }
}
