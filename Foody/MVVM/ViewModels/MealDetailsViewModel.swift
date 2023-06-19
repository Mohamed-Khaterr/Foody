//
//  MealDetailsViewModel.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import Foundation

final class MealDetailsViewModel {
    
    
    // MARK: - Public Variables
    public var showSkeletonAnimation: ((Bool) -> Void)?
    public var updateUI: ((MealDetails)->Void)?
    
    
    
    // MARK: - Private Variables
    private let mealID: String
    private var mealDetails: MealDetails?

    
    
    // MARK: - init
    init(mealID: String) {
        self.mealID = mealID
    }
    
    
    
    // MARK: - Methods
    public func fetchMealDetails() {
        showSkeletonAnimation?(true)
        Task {
            do {
                let mealDetailsResponse = try await NetworkManager.shared.request(endpoint: FreeMealDBEndPoint.details,
                                                                                  method: .get,
                                                                                  parameters: ["i": mealID],
                                                                                  type: MealDetailsResponse.self)
                
                guard let mealDetails = mealDetailsResponse.mealsDetails?[0] else { return }
                self.mealDetails = mealDetails
                DispatchQueue.main.async {
                    self.updateUI?(mealDetails)
                    self.showSkeletonAnimation?(false)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    public func getYoutubeVideoURL(from string: String) -> URLRequest? {
        guard
            let urlComponent = URLComponents(string: string),
            let queryItems = urlComponent.queryItems,
            let id = queryItems.first(where: { $0.name == "v" })?.value
        else { return nil }
        
        let urlString = "https://www.youtube.com/embed/\(id)?playsinline=1"
        let request = URLRequest(url: URL(string: urlString)!)
        return request
    }
    
    
    public func placeAnOrder(completionHandler: @escaping (CreateOrderViewController) -> Void) {
        guard let mealDetails = mealDetails else { return }
        let createOrderVC = CreateOrderViewController(meal: mealDetails)
        DispatchQueue.main.async {
            completionHandler(createOrderVC)
        }
    }
}
