//
//  MealCollectionViewCell.swift
//  Foody
//
//  Created by Khater on 6/5/23.
//

import UIKit
import SkeletonView


class MealCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "MealCollectionViewCell"
    
    // MARK: - UIComponents
    private let cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        // Blur Effect doesn't appear on Simulator perfectly use real device
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.masksToBounds = true
        blurEffectView.alpha = 0.8
        return blurEffectView
    }()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Meal"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViewsLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View & Sub View
    private func setupView() {
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = 10
        backgroundColor = .red
        isSkeletonable = true
    }
    
    private func setupSubViewsLayout() {
        // Add Subviews
        contentView.addSubview(cardView)
        [mealImageView, blurEffectView, mealNameLabel].forEach({ cardView.addSubview($0) })
        
        // Setup Constraints
        setupCardViewConstraints()
        setupMealImageViewConstraints()
        setupBlurEffectViewConstraints()
        setupMealNameLabelConstraints()
    }
    
    private func setupCardViewConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupMealImageViewConstraints() {
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }
    
    private func setupBlurEffectViewConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.centerXAnchor.constraint(equalTo: mealImageView.centerXAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: -8),
            blurEffectView.leadingAnchor.constraint(equalTo: mealImageView.leadingAnchor, constant: 8),
            blurEffectView.trailingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: -8)
        ])
    }
    
    
    private func setupMealNameLabelConstraints() {
        NSLayoutConstraint.activate([
            mealNameLabel.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 8),
            mealNameLabel.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: 8),
            mealNameLabel.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: -8),
            mealNameLabel.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -8),
        ])
    }
    
    
    // MARK: - Functions
    public func setValues(_ meal: Meal) {
        mealNameLabel.text = meal.name
        mealImageView.setImage(meal.image)
    }
    
    public func skeletonView(show: Bool) {
        if show {
            showAnimatedGradientSkeleton()
        } else {
            hideSkeleton()
        }
    }
}
