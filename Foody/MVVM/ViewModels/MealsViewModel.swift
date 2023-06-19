//
//  MealsViewModel.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import Foundation


final class MealsViewModel {
    
    // MARK: - Public Variables
    var reloadData: (()->Void)?
    
    public private(set) var isSkeletonAnimating: Bool = false
    
    public var numberOfItems: Int {
        // 3 is to create 3 cells with SkeletonViewAnimation
        return meals.isEmpty ? 3 : meals.count
    }
    
    
    
    // MARK: - Private Variables
    private var meals = [Meal]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    
    
    // MARK: - Methods
    public func itemAt(_ indexPath: IndexPath) -> Meal? {
        return meals.isEmpty ? nil : meals[indexPath.row]
    }
    
    public func didSelectItemAt(_ indexPath: IndexPath, compeltionHandler: @escaping (MealDetailsViewController) -> Void) {
        if meals.isEmpty { return }
        let meal = meals[indexPath.row]
        let mealDetailsVC = MealDetailsViewController(mealID: meal.id, showPlaceOrderButton: true)
        DispatchQueue.main.async {
            compeltionHandler(mealDetailsVC)
        }
    }
    
    public func fetchMeals(in type: MealsType){
        let parameters: [String: String]
        switch type {
        case .category(let name):
            parameters = ["c": name]
        case .country(let name):
            parameters = ["a": name]
        }
        
        isSkeletonAnimating = true
        Task{
            do {
                let mealsResponse = try await NetworkManager.shared.request(endpoint: FreeMealDBEndPoint.filter,
                                                                            method: .get,
                                                                            parameters: parameters,
                                                                            type: MealsResponse.self)
                meals = mealsResponse.meals
                isSkeletonAnimating = false
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
