//
//  FoodCategoryCollectionViewCell.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit
import SkeletonView


class FoodCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    // MARK: - UIComponents
    private let cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constant.defaultImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category name"
        label.textAlignment = .left
        label.textColor = .tintColor
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViewsLayout()
        isSkeletonable = true
        clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - SubViews Layout
    private func setupSubViewsLayout() {
        // Add Subviews
        addSubview(cardView)
        [categoryImageView, categoryNameLabel].forEach({ cardView.addSubview($0) })
        
        // Set Constraints
        setupCardViewConstraints()
        setupImageViewConstraints()
        setupNameLabelConstraints()
    }
    
    
    // MARK: - Constraints
    private func setupCardViewConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupImageViewConstraints() {
        NSLayoutConstraint.activate([
            categoryImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            categoryImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            categoryImageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.8),
            categoryImageView.widthAnchor.constraint(equalTo: categoryImageView.heightAnchor)
        ])
    }
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            categoryNameLabel.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor),
            categoryNameLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 12),
            categoryNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -4)
        ])
    }
    
    
    // MARK: - Functions
    public func setFoodCategory(_ category: FoodCategory) {
        categoryImageView.setImage(category.image)
        categoryNameLabel.text = category.name
    }
    
    public func skeletonView(_ isEnable: Bool) {
        if isEnable {
            showAnimatedGradientSkeleton()
        } else {
            hideSkeleton()
        }
    }
}
