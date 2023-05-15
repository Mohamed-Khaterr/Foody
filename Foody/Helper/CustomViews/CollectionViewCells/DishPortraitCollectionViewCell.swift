//
//  DishPortraitCollectionViewCell.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit
import SDWebImage

class DishPortraitCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DishPortraitCollectionViewCell"
    
    
    // MARK: - UIComponents
    private let cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dish Name"
        label.textAlignment = .center
        label.textColor = .tintColor
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    
    private let dishImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Calories"
        label.textAlignment = .natural
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "descriptionLabel Name"
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
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
        [nameLabel, dishImageView, caloriesLabel, descriptionLabel].forEach({ addSubview($0) })
        
        setupCardViewConstraints()
        setupNameLabelConstraints()
        setupImageViewConstraints()
        setupCaloriesLabelCoinstraints()
        setupDescriptionLabelCoinstraints()
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
    
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupImageViewConstraints() {
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            dishImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dishImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    private func setupCaloriesLabelCoinstraints() {
        NSLayoutConstraint.activate([
            caloriesLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 8),
            caloriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            caloriesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            caloriesLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func setupDescriptionLabelCoinstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    
    
    // MARK: - Functions
    func setup(_ dish: Dish) {
        nameLabel.text = dish.name
        descriptionLabel.text = dish.description
        
        dishImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        dishImageView.sd_setImage(with: URL(string: dish.image), placeholderImage: Constant.defaultImage)
    }
}
