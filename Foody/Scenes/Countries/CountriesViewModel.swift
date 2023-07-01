//
//  CountriesViewModel.swift
//  Foody
//
//  Created by Khater on 6/5/23.
//

import Foundation
import Combine


typealias CountriesInput = CountriesViewModel.Input
typealias CountriesOutput = CountriesViewModel.Output


final class CountriesViewModel {
    
    enum Input {
        case viewDidLoad
        case limitCountries(_ isLimitCountries: Bool)
        case selectContryAt(_ indexPath: IndexPath)
    }
    
    enum Output {
        case reloadData
        case navigateToCountryMeals(_ vc: MealsCollectionViewController)
        case errorOccur(title: String, message: String)
    }
    
    
    // MARK: - Public Variables
    public var numberOfItems: Int {
        return countries.count
    }
    
    public func itemForCell(at indexPath: IndexPath) -> Country {
        return countries[indexPath.row]
    }
    
    public private(set) var isAnimating = false
    
    
    // MARK: - Private Variables
    private let network: NetworkManagerType
    private var networkSubscriber: AnyCancellable?
    
    private let outputPublisher: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var countries: [Country] = [Country(name: "Loading"), Country(name: "Loading"), Country(name: "Loading")]
    private var isLimitCountries = false
    
    
    init(network: NetworkManagerType = NetworkManager()) {
        self.network = network
    }
    
    deinit {
        print("deinit: CountriesViewModel")
    }
    
    
    // MARK: - Methods
    public func bind(input subscription: AnyPublisher<CountriesInput, Never>) -> AnyPublisher<CountriesOutput, Never> {
        subscription
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                guard let self = self else { return }
                // Handle View inputs
                switch events {
                case .viewDidLoad:
                    self.fetchCountries()
                    
                case .limitCountries(let isLimitCountries):
                    self.isLimitCountries = isLimitCountries
                    self.fetchCountries()
                    
                case .selectContryAt(let indexPath):
                    let country = self.countries[indexPath.row]
                    let countryMealsVC = MealsCollectionViewController(in: .country(country.name))
                    outputPublisher.send(.navigateToCountryMeals(countryMealsVC))
                }
            }
            .store(in: &cancellables)
        
        return outputPublisher.eraseToAnyPublisher()
    }
    
    
    
    private func fetchCountries() {
        isAnimating = true
        do {
            let requst = try network.createURLRequest(endpoint: MealDBEndpoint.list, method: .get, parameters: ["a": "list"])
            
            // Handle Network Response
            networkSubscriber?.cancel()
            networkSubscriber = network.request(with: requst, type: CountriesResponse.self)
                .map(\.countries)
                .map({ [weak self] countries in
                    guard let self = self else { return countries }
                    return self.isLimitCountries ? countries.prefix(4).map({$0}) : countries
                })
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isAnimating = false
                        self?.outputPublisher.send(.reloadData)
                        
                    case .failure(let error):
                        self?.outputPublisher.send(.errorOccur(title: "Network", message: error.localizedDescription))
                    }
                } receiveValue: { [weak self] countries in
                    guard let self = self else { return }
                    self.countries = countries
                }

        } catch {
            outputPublisher.send(.errorOccur(title: "URL Request", message: error.localizedDescription))
        }
    }
}
