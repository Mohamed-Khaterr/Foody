//
//  FoodCategoriesViewModel.swift
//  Foody
//
//  Created by Khater on 5/23/23.
//

import Foundation


class FoodCategoriesViewModel {
    
    // MARK: - Public Variables
    public var reloadData: (()->Void)?
    
    public private(set) var isSkeletonAnimating: Bool = false
    
    public var numberOfItems: Int {
        // return 3 if it's empty to create 3 cells with SkeletonViewAnimation
        return categories.isEmpty ? 3 : categories.count
    }
    
   
    
    // MARK: - Private Variables
    private var categories = [FoodCategory]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    
    // MARK: - Methods
    public func itemAt(_ indexPath: IndexPath) -> FoodCategory? {
        return categories.isEmpty ? nil : categories[indexPath.row]
    }
    
    public func didSelectItemAt(_ indexPath: IndexPath, completionHandler: @escaping (MealsCollectionViewController) -> Void) {
        if categories.isEmpty { return }
        let category = categories[indexPath.row]
        let mealsVC = MealsCollectionViewController(in: .category(category.name))
        DispatchQueue.main.async {
            completionHandler(mealsVC)
        }
    }
    
    public func fetchFoodCategories() {
        isSkeletonAnimating = true
        Task {
            do {
                let foodCategoriesResponse = try await NetworkManager.shared.request(endpoint: FreeMealDBEndPoint.categories, method: .get, parameters: [:], type: FoodCategoriesResponse.self)
                categories = foodCategoriesResponse.categories
                isSkeletonAnimating = false
            } catch {
                print(error)
            }
        }
    }
}
