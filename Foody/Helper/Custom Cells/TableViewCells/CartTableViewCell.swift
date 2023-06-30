//
//  OrderTableViewCell.swift
//  Foody
//
//  Created by Khater on 5/15/23.
//

import UIKit


class CartTableViewCell: UITableViewCell {
    
    // MARK: - UIComponents
    private let cardView: UIView = {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Amount: 0"
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let mealNameLabel: UILabel = {
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
        selectionStyle = .none
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
        [mealImageView, amountLabel, mealNameLabel, usernameLabel].forEach({ cardView.addSubview($0) })
        
        // Set Constraints
        setupCardViewConstraints()
        setupMealImageViewConstraints()
        setupAmountLabelConstraints()
        setupMealNameLabelConstraints()
        setupUsernameLabelConstraints()
    }
    
    
    // MARK: - Constraints
    private func setupCardViewConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    private func setupMealImageViewConstraints() {
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            mealImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            mealImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            mealImageView.heightAnchor.constraint(equalToConstant: 65),
            mealImageView.widthAnchor.constraint(equalTo: mealImageView.heightAnchor)
        ])
    }
    
    private func setupAmountLabelConstraints() {
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupMealNameLabelConstraints() {
        NSLayoutConstraint.activate([
            mealNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            mealNameLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 16),
            mealNameLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -8),
        ])
    }
    
    private func setupUsernameLabelConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: mealNameLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: mealNameLabel.trailingAnchor),
        ])
    }
    
    
    
    // MARK: - Functions
    func setup(_ order: Order) {
        mealImageView.setImage(order.mealImage ?? "")
        mealNameLabel.text = order.mealName
        usernameLabel.text = order.userName
        amountLabel.text = "Amount: \(String(order.quantity))"
    }
}
