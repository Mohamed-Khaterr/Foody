//
//  MealDetailsViewController.swift
//  Foody
//
//  Created by Khater on 5/15/23.
//

import UIKit
import WebKit


class MealDetailsViewController: UIViewController {
    
    // MARK: - Variables
    private let mainView: MealDetailsView
    private let viewModel: MealDetailsViewModel
    
    
    init(mealID: String, showPlaceOrderButton: Bool) {
        viewModel = MealDetailsViewModel(mealID: mealID)
        mainView = MealDetailsView(showPlaceOrderButton: showPlaceOrderButton)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View
        mainView.delegate = self
        mainView.webViewDelegate = self
        
        
        // ViewModel
        viewModel.fetchMealDetails()
        
        viewModel.showSkeletonAnimation = { [weak self] isSkeletonAnimating in
            self?.mainView.skeletonView(show: isSkeletonAnimating)
        }
        
        viewModel.updateUI = { [weak self] meal in
            guard let strongSelf = self else { return }
            strongSelf.navigationItem.title = meal.name
            strongSelf.mainView.setData(meal)
            
            if let youtubeVideoRequest = strongSelf.viewModel.getYoutubeVideoURL(from: meal.youtubeVideo) {
                strongSelf.mainView.setYoutubeVideo(with: youtubeVideoRequest)
            }
        }
    }
}


// MARK: - MealDetailsViewDelegate
extension MealDetailsViewController: MealDetailsViewDelegate {
    func placeOrderButtonPressed() {
        viewModel.placeAnOrder { [weak self] vc in
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        }
    }
}



// MARK: - WKNavigationDelegate
extension MealDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mainView.hideSkeletonViewOnYoutubeVideo()
    }
}
