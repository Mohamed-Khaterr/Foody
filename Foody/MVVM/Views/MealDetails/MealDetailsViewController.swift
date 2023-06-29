//
//  MealDetailsViewController.swift
//  Foody
//
//  Created by Khater on 5/15/23.
//

import UIKit
import WebKit
import Combine


class MealDetailsViewController: UIViewController {
    
    // MARK: - Variables
    private let mainView: MealDetailsView
    private let viewModel: MealDetailsViewModel
    private let inputPublisher: PassthroughSubject<MealDetailsViewModel.Input, Never> = .init()
    private var outputSubscriber: AnyCancellable?
    
    
    init(mealID: String, showPlaceOrderButton: Bool) {
        viewModel = MealDetailsViewModel(mealID: mealID)
        mainView = MealDetailsView(showPlaceOrderButton: showPlaceOrderButton)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("deinit: MealDetailsViewController")
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
        bind()
        inputPublisher.send(.viewDidLoad)
    }
    
    private func bind() {
        outputSubscriber = viewModel.bind(input: inputPublisher.eraseToAnyPublisher())
            .sink(receiveValue: { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .skeletonAnimation(let isAnimating):
                    self.mainView.skeletonAnimation(isAnimating: isAnimating)
                    
                case .uiUpdateWithDetails(let details, let youtubeRequest):
                    self.navigationItem.title = details.name
                    self.mainView.image = details.image
                    self.mainView.tags = details.tags
                    self.mainView.category = details.category
                    self.mainView.instructions = details.instructions
                    self.mainView.loadYoutubeVideo(with: youtubeRequest)
                    
                    
                case .goToCreateOrderVC(let createOrderVC):
                    let nav = UINavigationController(rootViewController: createOrderVC)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                    
                case .error(let title, let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert, animated: true)
                }
            })
    }
}


// MARK: - MealDetailsViewDelegate
extension MealDetailsViewController: MealDetailsViewDelegate {
    func placeOrderButtonPressed() {
        inputPublisher.send(.placeOrderButtonPressed)
    }
}



// MARK: - WKNavigationDelegate
extension MealDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mainView.hideSkeletonViewOnYoutubeVideo()
    }
}
