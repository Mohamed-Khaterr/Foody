//
//  DishLandscapeCollectionViewCell.swift
//  Foody
//
//  Created by Khater on 5/14/23.
//

import UIKit
import SDWebImage


class DishLandscapeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DishLandscapeCollectionViewCell"
    
    
    // MARK: - UIComponents
    private let cardView: UIView = {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private let dishImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dish Name"
        label.textAlignment = .left
        label.textColor = .tintColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dish Descritpion"
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Calories"
        label.textAlignment = .left
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(cardView)
        [dishImageView, nameLabel, descriptionLabel, caloriesLabel].forEach({ cardView.addSubview($0) })
        
        setupCardViewConstraints()
        setupDishImageViewConstraints()
        setupNameLabelConstraints()
        setupDiscriptionLabelConstraints()
        setupCaloriesLabelConstraints()
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
    
    private func setupDishImageViewConstraints() {
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dishImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dishImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            dishImageView.widthAnchor.constraint(equalTo: dishImageView.heightAnchor)
        ])
    }
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: dishImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupDiscriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func setupCaloriesLabelConstraints() {
        NSLayoutConstraint.activate([
            caloriesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            caloriesLabel.leadingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: 8),
            caloriesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            caloriesLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    
    // MARK: - Functions
    func setup(_ dish: Dish) {
        dishImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        dishImageView.sd_setImage(with: URL(string: dish.image), placeholderImage: Constant.defaultImage)
        nameLabel.text = dish.name
        descriptionLabel.text = dish.description
        caloriesLabel.text = dish.description
    }
}
