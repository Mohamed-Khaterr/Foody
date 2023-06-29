//
//  AddToCartViewModel.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import Foundation
import Combine


class AddToCartViewModel {
    
    enum Input {
        case viewDidLoad
        case plusButtonPressed
        case minusButtonPressed
        case usernametextFieldReturnButtonPressed(_ text: String?)
        case orderButtonPressed
    }
    
    enum Output {
        case updateElements(name: String, image: String, quantity: String)
        case updateQuantityLabel(text: String)
        case elementsEnable(_ isEnabled: Bool)
        case alert(title: String, message: String, dismissVCOnAction: Bool)
    }
    
    
    
    // MARK: - Private Variables
    private let mealDetails: MealDetails
    private let outputPublisher: PassthroughSubject<AddToCartViewModel.Output, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    private var username: String?
    private var quantity: Int = 1 {
        didSet {
            outputPublisher.send(.updateQuantityLabel(text: String(quantity)))
        }
    }
    
    
    
    // MARK: - init
    init(mealDetails: MealDetails) {
        self.mealDetails = mealDetails
    }
    
    deinit {
        print("deinit: CreateOrderViewModel")
    }
    
    
    
    // MARK: - Methods
    public func bind(input subscription: AnyPublisher<AddToCartViewModel.Input, Never>) -> AnyPublisher<AddToCartViewModel.Output, Never> {
        subscription
            .receive(on: DispatchQueue.global())
            .sink { [weak self] events in
            guard let self = self else { return }
            switch events {
            case .viewDidLoad:
                self.outputPublisher.send(.updateElements(name: self.mealDetails.name,
                                                          image: self.mealDetails.image,
                                                          quantity: String(self.quantity)))
                
            case .plusButtonPressed:
                self.quantity += 1
                
            case .minusButtonPressed:
                // instead of if
                (self.quantity > 1) ? (self.quantity -= 1) : (nil)
                
            case .usernametextFieldReturnButtonPressed(let text):
                self.username = text
                
            case .orderButtonPressed:
                self.outputPublisher.send(.elementsEnable(false))
                guard
                    let username = self.username,
                    !username.isEmpty
                else {
                    self.outputPublisher.send(.alert(title: "Username", message: "Username can not be empty!", dismissVCOnAction: false))
                    self.outputPublisher.send(.elementsEnable(true))
                    return
                }
                self.createOrder(userName: username)
            }
        }
        .store(in: &cancellable)
        
//        return outputPublisher.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        return outputPublisher.eraseToAnyPublisher()
    }
    
    private func createOrder(userName: String) {
        let orederManager = OrderManager()
        orederManager.createOrder(.init(mealId: mealDetails.id, mealName: mealDetails.name, mealImage: mealDetails.image, date: Date(), userName: userName, quantity: quantity))
        outputPublisher.send(.alert(title: "Success", message: "Order created successfully", dismissVCOnAction: true))
        self.outputPublisher.send(.elementsEnable(true))
    }
}
