//
//  CountriesViewModel.swift
//  Foody
//
//  Created by Khater on 6/5/23.
//

import Foundation


final class CountriesViewModel {
    
    // MARK: - Public Variables
    public var reloadData: (() -> Void)?
    
    public private(set) var isSkeletonAnimating = false
    
    public var numberOfItems: Int {
        // 3 is to create 3 cells with SkeletonViewAnimation
        return countries.isEmpty ? 3 : countries.count
    }
    
    
    
    // MARK: - Private Variables
    private var countries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    
    // MARK: - Methods
    public func itemAt(_ indexPath: IndexPath) -> Country? {
        return countries.isEmpty ? nil : countries[indexPath.row]
    }
    
    public func didSelectItemAt(_ indexPath: IndexPath, completionHandler: @escaping (MealsCollectionViewController) -> Void) {
        if countries.isEmpty { return }
        let country = countries[indexPath.row]
        let mealsVC = MealsCollectionViewController(in: .country(country.name))
        DispatchQueue.main.async {
            completionHandler(mealsVC)
        }
    }
    
    
    public func fetchCountries() {
        isSkeletonAnimating = true
        Task {
            do {
                let countriesResponse = try await NetworkManager.shared.request(endpoint: FreeMealDBEndPoint.list, method: .get, parameters: ["a":"list"], type: CountriesResponse.self)
                countries = countriesResponse.countries
                isSkeletonAnimating = false
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
