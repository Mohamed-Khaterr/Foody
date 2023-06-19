//
//  SearchViewModel.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import Foundation


class SearchViewModel {
    
    // MARK: - Public Variables
    public private(set) var isNoResult: Bool = false
    
    public var relaodData: (()->Void)?
    
    public var numberOfItems: Int {
        return meals.count
    }
    
    
    // MARK: - Private Variables
    private var searchTask: Task<(), Never>?
    private var meals = [MealDetails]() {
        didSet {
            DispatchQueue.main.async {
                self.relaodData?()
            }
        }
    }
    
    
    
    // MARK: - Methods
    public func itemAt(_ indexPath: IndexPath) -> MealDetails {
        return meals[indexPath.row]
    }
    
    public func didSelectItemAt(_ indexPath: IndexPath, completionHandler:  @escaping (MealDetailsViewController) -> Void) {
        let meal = meals[indexPath.row]
        let mealDetailsVC = MealDetailsViewController(mealID: meal.id, showPlaceOrderButton: true)
        DispatchQueue.main.async {
            completionHandler(mealDetailsVC)
        }
    }
    
    func search(_ text: String){
        if text.isEmpty {
            searchTask?.cancel()
            searchTask = nil
            self.meals = []
            isNoResult = false
            return
        }
        
        searchTask = Task {
            do {
                let mealsResponse = try await NetworkManager.shared.request(endpoint: FreeMealDBEndPoint.search, method: .get, parameters: ["s": text], type: MealDetailsResponse.self)
                if let result = mealsResponse.mealsDetails {
                    self.meals = result
                    isNoResult = false
                } else {
                    self.meals = []
                    isNoResult = true
                }
                
                
            } catch {
                print(error)
            }
        }
    }
}
