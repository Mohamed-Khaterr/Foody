//
//  FoodCategoriesViewModel.swift
//  Foody
//
//  Created by Khater on 5/23/23.
//

import Foundation
import Combine


typealias FoodCategoriesInput = FoodCategoriesViewModel.Input
typealias FoodCategoriesOutput = FoodCategoriesViewModel.Output


final class FoodCategoriesViewModel {
    
    enum Input {
        case viewDidLoad
        case limitItems(_ isLimited: Bool)
        case didSelectItemAt(_ indexPath: IndexPath)
    }
    
    enum Output {
        case reloadData
        case error(title: String, message: String)
        case navigateToCategoryMeals(_ vc: MealsCollectionViewController)
    }
    
    
    
    // MARK: - Variables
    private let network: NetworkManagerType
    private var networkSubscirber: AnyCancellable?
    private let outputPublisher: PassthroughSubject<FoodCategoriesOutput, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    private var foodCategories: [FoodCategory] = [
        FoodCategory(id: "", name: "Loading", description: "", image: ""),
        FoodCategory(id: "", name: "Loading", description: "", image: ""), FoodCategory(id: "", name: "Loading", description: "", image: "")
    ]
    
    private var isLimitedCategories = false
    
    
    
    // MARK: - CollectionView Data
    public var numberOfItems: Int {
        return foodCategories.count
    }
    
    public func itemForCell(at indexPath: IndexPath) -> FoodCategory {
        return foodCategories[indexPath.row]
    }
    
    public private(set) var isAnimating = false
    
    
    
    // MARK: - Init
    init(network: NetworkManagerType = NetworkManager()) {
        self.network = network
    }
    
    deinit {
        print("deinit: FoodCategoriesViewModel")
    }
    
    
    
    // MARK: - Methods
    public func bind(ViewInput subscription: AnyPublisher<FoodCategoriesInput, Never>) -> AnyPublisher<FoodCategoriesOutput, Never> {
        subscription.sink { [weak self] events in
            guard let self = self else { return }
            switch events {
            case .viewDidLoad:
                self.fetchFoodCategories()
                
            case .limitItems(let isLimited):
                self.isLimitedCategories = isLimited
                self.fetchFoodCategories()
                
            case .didSelectItemAt(let indexPath):
                let category = self.foodCategories[indexPath.row]
                let mealsVC = MealsCollectionViewController(in: .category(category.name))
                outputPublisher.send(.navigateToCategoryMeals(mealsVC))
            }
        }
        .store(in: &cancellable)
        
        return outputPublisher.eraseToAnyPublisher()
    }
    
    
    private func fetchFoodCategories() {
        isAnimating = true

        do {
            let request = try network.createURLRequest(endpoint: MealDBEndpoint.categories, method: .get, parameters: ["a":"s"])
            
            networkSubscirber?.cancel()
            networkSubscirber = nil
            networkSubscirber = network.request(with: request, type: FoodCategoriesResponse.self)
                .map(\.categories)
                .map({ [weak self] categories in
                    guard let self = self else { return categories }
                    return self.isLimitedCategories ? categories.prefix(5).map({$0}) : categories
                })
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isAnimating = false
                        self?.outputPublisher.send(.reloadData)
                        
                    case .failure(let error):
                        self?.outputPublisher.send(.error(title: "Network", message: error.localizedDescription))
                    }
                    
                } receiveValue: { [weak self] foodCategories in
                    self?.foodCategories = foodCategories
                }
            
        } catch {
            outputPublisher.send(.error(title: "URL Request", message: error.localizedDescription))
        }
    }
}
