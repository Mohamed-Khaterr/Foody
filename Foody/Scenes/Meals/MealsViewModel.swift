//
//  MealsViewModel.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import Foundation
import Combine


typealias MealsInput = MealsViewModel.Input
typealias MealsOutput = MealsViewModel.Output


final class MealsViewModel {
    
    enum Input {
        case viewDidLoad
        case didSelectItemAt(_ indexPath: IndexPath)
    }
    
    enum Output {
        case reloadData
        case error(title: String, message: String)
        case goToMealDetailsVC(_ vc: MealDetailsViewController)
    }
    
    
    
    public var mealsTypeName: String {
        switch type {
        case .category(let cateogryName): return cateogryName
        case .country(let countryName): return countryName
        }
    }
    
    public var numberOfItems: Int {
        return meals.count
    }
    
    public func itemForCell(at indexPath: IndexPath) -> Meal {
        return meals[indexPath.row]
    }
    
    public private(set) var isSkeletonAnimating = false
    
    
    private let network: NetworkManagerType
    private var networkSubscriber: AnyCancellable?
    private let outputPublisher: PassthroughSubject<MealsOutput, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    private let type: MealsType
    private var meals: [Meal] = [
        Meal(id: "", name: "Loading", image: ""),
        Meal(id: "", name: "Loading", image: ""),
        Meal(id: "", name: "Loading", image: "")
    ]
    
    
    init(network: NetworkManagerType = NetworkManager(), type: MealsType) {
        self.network = network
        self.type = type
    }
    
    deinit {
        print("deinit: MealsViewModel")
    }
    
    
    public func bind(input subscription: AnyPublisher<MealsInput, Never>) -> AnyPublisher<MealsOutput, Never> {
        subscription
            .sink { [weak self] events in
                guard let self = self else { return }
                switch events {
                case .viewDidLoad:
                    self.fetchMeals()
                    
                case .didSelectItemAt(let indexPath):
                    let meal = self.meals[indexPath.row]
                    let mealDetailsVC = MealDetailsViewController(mealID: meal.id, showPlaceOrderButton: true)
                    self.outputPublisher.send(.goToMealDetailsVC(mealDetailsVC))
                }
            }
            .store(in: &cancellable)
        
        return outputPublisher.eraseToAnyPublisher()
    }
    
    private func fetchMeals(){
        isSkeletonAnimating = true
        do {
            let request = try network.createURLRequest(endpoint: MealDBEndpoint.filter,
                                                       method: .get,
                                                       parameters: getParameters())
            
            networkSubscriber = nil
            networkSubscriber = network.request(with: request, type: MealsResponse.self)
                .map(\.meals)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        self.isSkeletonAnimating = false
                        self.outputPublisher.send(.reloadData)
                        
                    case .failure(let error):
                        self.outputPublisher.send(.error(title: "Network", message: error.localizedDescription))
                    }
                }, receiveValue: { [weak self] meals in
                    self?.meals = meals
                })
            
        } catch {
            outputPublisher.send(.error(title: "URL Request", message: error.localizedDescription))
        }
    }
    
    private func getParameters() -> [String: String] {
        let parameters: [String: String]
        switch type {
        case .category(let cateogryName): parameters = ["c": cateogryName]
        case .country(let countryName): parameters = ["a": countryName]
        }
        return parameters
    }
}
