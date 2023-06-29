//
//  SearchViewModel.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import Foundation
import Combine


class SearchViewModel {
    
    enum Input {
        case viewDidLoad
        case searchTextFieldDidChange(_ text: String)
        case didSelectItemAt(_ indexPath: IndexPath)
    }
    
    enum Output {
        case reloadData
        case footerAppear(isAppear: Bool)
        case goToMealDetailsVC(_ vc: MealDetailsViewController)
        case error(title: String, message: String)
    }

    public var numberOfItems: Int {
        return meals.count
    }
    
    public func itemForCell(at indexPath: IndexPath) -> Meal {
        let mealDetails = meals[indexPath.row]
        let meal = Meal(id: mealDetails.id, name: mealDetails.name, image: mealDetails.image)
        return meal
    }
    
    public private(set) var isItemAnimating = false
    
    
    private let network: NetworkManagerType
    private var networkSubscriber: AnyCancellable?
    private let outputPublisher: PassthroughSubject<SearchViewModel.Output, Never> = .init()
    private var inputSubscriber: AnyCancellable?
    
    private var meals = [MealDetails]()
    private let mealsForLoading: [MealDetails] = [
        MealDetails(id: "", name: "Loading", category: "", area: "", instructions: "", image: "", tags: nil, youtubeVideo: ""),
        MealDetails(id: "", name: "Loading", category: "", area: "", instructions: "", image: "", tags: nil, youtubeVideo: ""),
        MealDetails(id: "", name: "Loading", category: "", area: "", instructions: "", image: "", tags: nil, youtubeVideo: "")
    ]
    
    
    
    init(network: NetworkManagerType = NetworkManager()) {
        self.network = network
    }
    
    deinit {
        print("deinit: SearchViewModel")
    }
    
    
    // MARK: - Methods
    public func bind(input subscription: AnyPublisher<SearchViewModel.Input, Never>) -> AnyPublisher<SearchViewModel.Output, Never> {
        inputSubscriber = nil
        inputSubscriber = subscription.sink { [weak self] events in
            guard let self = self else { return }
            switch events {
            case .viewDidLoad:
                self.outputPublisher.send(.footerAppear(isAppear: false))
                
            case .searchTextFieldDidChange(let text):
                self.fetchSearch(for: text)
                
            case .didSelectItemAt(let indexPath):
                let meal = self.meals[indexPath.row]
                let mealDetailsVC = MealDetailsViewController(mealID: meal.id, showPlaceOrderButton: true)
                self.outputPublisher.send(.goToMealDetailsVC(mealDetailsVC))
            }
        }
        return outputPublisher.eraseToAnyPublisher()
    }
    
    private func fetchSearch(for text: String){
        networkSubscriber = nil
        meals = mealsForLoading
        isItemAnimating = true
        outputPublisher.send(.footerAppear(isAppear: false))
        
        if text.isEmpty {
            meals = []
            isItemAnimating = false
            outputPublisher.send(.reloadData)
            return
        }
        
        do {
            let request = try network.createURLRequest(endpoint: MealDBEndpoint.search,
                                                       method: .get,
                                                       parameters: ["s": text])
            
            networkSubscriber = nil
            networkSubscriber = network.request(with: request, type: SearchResponse.self)
                .map(\.mealsDetails)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        self.isItemAnimating = false
                        self.outputPublisher.send(.reloadData)
                        
                    case .failure(let error):
                        self.outputPublisher.send(.error(title: "Network", message: error.localizedDescription))
                    }
                }, receiveValue: { [weak self] meals in
                    guard let meals = meals else {
                        self?.outputPublisher.send(.footerAppear(isAppear: true))
                        self?.meals = []
                        return
                    }
                    self?.meals = meals
                })
            
        } catch {
            outputPublisher.send(.error(title: "URL Request", message: error.localizedDescription))
        }
    }
}
