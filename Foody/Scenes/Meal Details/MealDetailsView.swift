//
//  MealDetailsView.swift
//  Foody
//
//  Created by Khater on 6/6/23.
//

import UIKit
import WebKit
import SkeletonView


@objc protocol MealDetailsViewDelegate: AnyObject {
    func placeOrderButtonPressed()
}


final class MealDetailsView: UIView {
    
    
    // MARK: - UIComponents
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tas"
        label.numberOfLines = 1
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category"
        label.numberOfLines = 1
        label.textColor = .red
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var mealInstructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Meal Instructions"
        label.numberOfLines = 3
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedOnInstructionsLable))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private let youtubeVideoWebView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .gray
        webView.layer.cornerRadius = 10
        webView.clipsToBounds = true
        webView.configuration.allowsInlineMediaPlayback = true
        return webView
    }()
    
    private lazy var placeOrderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to cart!", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.addTarget(delegate, action: #selector(delegate?.placeOrderButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Variables
    weak var delegate: MealDetailsViewDelegate?
    weak var webViewDelegate: WKNavigationDelegate? {
        didSet {
            youtubeVideoWebView.navigationDelegate = webViewDelegate
        }
    }
    
    
    // MARK: - init
    init(showPlaceOrderButton: Bool) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
        [mealImageView, tagsLabel, categoryLabel, mealInstructionsLabel, youtubeVideoWebView].forEach({ $0.isSkeletonable = true })
        
        if !showPlaceOrderButton {
            placeOrderButton.isHidden = false
            placeOrderButton.removeFromSuperview()
            
            youtubeVideoWebView.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -18).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [mealImageView, tagsLabel, categoryLabel, mealInstructionsLabel, youtubeVideoWebView, placeOrderButton].forEach({ scrollContainer.addSubview($0) })
        
        setupScrollViewConstraints()
        setupScrollContainerConstraints()
        setupMealImageViewConstraints()
        setupTagsLabelConstraints()
        setupCategoryLabelConstraints()
        setupMealInstructionsLabelConstraints()
        setupYoutubeWebViewConstrints()
        setupPlaceOrderButtonConstraints()
    }
    
    
    // MARK: - Constraints
    private func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupScrollContainerConstraints() {
        NSLayoutConstraint.activate([
            scrollContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContainer.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func setupMealImageViewConstraints() {
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor)
        ])
    }
    
    private func setupTagsLabelConstraints() {
        NSLayoutConstraint.activate([
            tagsLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupCategoryLabelConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tagsLabel.trailingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupMealInstructionsLabelConstraints() {
        NSLayoutConstraint.activate([
            mealInstructionsLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            mealInstructionsLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 16),
            mealInstructionsLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16),
            mealInstructionsLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupYoutubeWebViewConstrints() {
        NSLayoutConstraint.activate([
            youtubeVideoWebView.topAnchor.constraint(equalTo: mealInstructionsLabel.bottomAnchor, constant: 16),
            youtubeVideoWebView.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            youtubeVideoWebView.widthAnchor.constraint(equalToConstant: 350),
            youtubeVideoWebView.heightAnchor.constraint(equalToConstant: 165)
        ])
    }
    
    private func setupPlaceOrderButtonConstraints() {
        NSLayoutConstraint.activate([
            placeOrderButton.topAnchor.constraint(equalTo: youtubeVideoWebView.bottomAnchor, constant: 24),
            placeOrderButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -18),
            placeOrderButton.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            placeOrderButton.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.8),
            placeOrderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    // MARK: - Functions
    @objc private func didTappedOnInstructionsLable() {
        if mealInstructionsLabel.numberOfLines == 0 {
            mealInstructionsLabel.numberOfLines = 3
        } else {
            mealInstructionsLabel.numberOfLines = 0
        }
    }
    
    func skeletonAnimation(isAnimating: Bool) {
        if isAnimating {
            [mealImageView, tagsLabel, categoryLabel, mealInstructionsLabel, youtubeVideoWebView].forEach({ $0.showAnimatedGradientSkeleton() })
        } else {
            [mealImageView, tagsLabel, categoryLabel, mealInstructionsLabel].forEach({ $0.hideSkeleton() })
        }
    }
    
    func hideSkeletonViewOnYoutubeVideo() {
        youtubeVideoWebView.hideSkeleton()
    }
    
    // MARK: - Setter
    public var image: String = "" {
        didSet{
            mealImageView.setImage(image)
        }
    }
    
    public var tags: String? = nil {
        didSet {
            tagsLabel.text = tags
        }
    }
    
    public var category: String? = nil {
        didSet {
            categoryLabel.text = category
        }
    }
    
    public var instructions: String? = nil {
        didSet {
            mealInstructionsLabel.text = instructions
        }
    }
    
    func loadYoutubeVideo(with requet: URLRequest) {
        youtubeVideoWebView.load(requet)
    }
}
