//
//  OrderTableViewCell.swift
//  Foody
//
//  Created by Khater on 5/15/23.
//

import UIKit
import SDWebImage


class OrderTableViewCell: UITableViewCell {
    
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
    
    private let dishNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dish Name"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .tintColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "User Name"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    
    // MARK: - Variables
    static let identifier = "OrderTableViewCell"
    
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(cardView)
        [dishImageView, dishNameLabel, usernameLabel].forEach({ cardView.addSubview($0) })
        
        // Set Constraints
        setupCardViewConstraints()
        setupDishImageViewConstraints()
        setupDishNameLabelConstraints()
        setupUsernameLabelConstraints()
    }
    
    
    // MARK: - Constraints
    private func setupCardViewConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    private func setupDishImageViewConstraints() {
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            dishImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            dishImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            dishImageView.widthAnchor.constraint(equalTo: dishImageView.heightAnchor)
        ])
    }
    
    private func setupDishNameLabelConstraints() {
        NSLayoutConstraint.activate([
            dishNameLabel.topAnchor.constraint(equalTo: dishImageView.topAnchor),
            dishNameLabel.leadingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: 16),
            dishNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupUsernameLabelConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: dishNameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: dishNameLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: dishNameLabel.trailingAnchor),
        ])
    }
    
    
    
    // MARK: - Functions
    func setup(_ order: Order) {
        dishImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        dishImageView.sd_setImage(with: URL(string: order.image), placeholderImage: Constant.defaultImage)
        dishNameLabel.text = order.dishName
        usernameLabel.text = order.username
    }
}
