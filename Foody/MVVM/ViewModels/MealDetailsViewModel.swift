//
//  MealDetailsViewModel.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import Foundation
import Combine

typealias  MealDetailsInput = MealDetailsViewModel.Input
typealias MealDetailsOutput = MealDetailsViewModel.Output


final class MealDetailsViewModel {
    
    enum Input {
        case viewDidLoad
        case placeOrderButtonPressed
    }
    
    enum Output {
        case skeletonAnimation(isAnimating: Bool)
        case uiUpdateWithDetails(_ details: MealDetails, youtubeVideoRequest: URLRequest)
        case goToCreateOrderVC(_ vc: CreateOrderViewController)
        case error(title: String, message: String)
    }
    
    private let network: NetworkManagerType
    private let outputPublisher: PassthroughSubject<MealDetailsOutput, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    
    
    // MARK: - Private Variables
    private let mealID: String
    private var mealDetails: MealDetails?

    
    
    // MARK: - init
    init(network: NetworkManagerType = NetworkManager(), mealID: String) {
        self.network = network
        self.mealID = mealID
    }
    
    
    deinit {
        print("deinit: MealDetailsViewModel")
    }
    
    
    public func bind(input subscription: AnyPublisher<MealDetailsInput, Never>) -> AnyPublisher<MealDetailsOutput, Never> {
        subscription.sink { [weak self] events in
            guard let self = self else { return }
            switch events {
            case .viewDidLoad:
                self.fetchMealDetails()
                
            case .placeOrderButtonPressed:
                guard let mealDetails = self.mealDetails else { return }
                let createOrderVC = CreateOrderViewController(meal: mealDetails)
                self.outputPublisher.send(.goToCreateOrderVC(createOrderVC))
            }
        }
        .store(in: &cancellable)
        return outputPublisher.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    
    
    // MARK: - Methods
    private func fetchMealDetails() {
        outputPublisher.send(.skeletonAnimation(isAnimating: true))
        
        do {
            let request = try network.createURLRequest(endpoint: MealDBEndpoint.details, method: .get, parameters: ["i": mealID])
            
            network.request(with: request, type: MealDetailsResponse.self)
                .map(\.mealsDetails)
                .tryMap({ $0.isEmpty ? nil : $0[0] })
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        self.outputPublisher.send(.skeletonAnimation(isAnimating: false))
                        guard let mealDetails = self.mealDetails else {
                            self.outputPublisher.send(.error(title: "Meal Details", message: "Not found any details about this meal."))
                            return
                        }
                        guard let request = self.getYoutubeVideoURLRequest(from: mealDetails.youtubeVideo) else {
                            return self.outputPublisher.send(.error(title: "Youtube Video", message: "Can't create request for youtube video."))
                        }
                        self.outputPublisher.send(.uiUpdateWithDetails(mealDetails, youtubeVideoRequest: request))
                        
                    case .failure(let error):
                        self.outputPublisher.send(.error(title: "Network", message: error.localizedDescription))
                    }
                } receiveValue: { [weak self] mealDetails in
                    self?.mealDetails = mealDetails
                }
                .store(in: &cancellable)

            
        } catch {
            outputPublisher.send(.error(title: "URL Request", message: error.localizedDescription))
        }
    }
    
    private func getYoutubeVideoURLRequest(from string: String) -> URLRequest? {
        guard
            let urlComponent = URLComponents(string: string),
            let queryItems = urlComponent.queryItems,
            let id = queryItems.first(where: { $0.name == "v" })?.value
        else { return nil }
        
        let urlString = "https://www.youtube.com/embed/\(id)?playsinline=1"
        let request = URLRequest(url: URL(string: urlString)!)
        return request
    }
}
