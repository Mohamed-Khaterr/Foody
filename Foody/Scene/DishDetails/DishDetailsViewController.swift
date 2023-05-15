//
//  DishDetailsViewController.swift
//  Foody
//
//  Created by Khater on 5/15/23.
//

import UIKit
import SDWebImage


class DishDetailsViewController: UIViewController {
    
    
    // MARK: - UIComponents
    private let dishImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dish Name"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .tintColor
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Calories"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .red
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dish Descritpion"
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.textColor = .gray
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your name"
        textField.keyboardType = .default
        textField.returnKeyType = .done
        return textField
    }()
    
    private let orderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Place Order", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    // MARK: - Variables
    
    
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Layout
    private func setupLayout() {
        [dishImageView, nameLabel, caloriesLabel, descriptionLabel, textField, orderButton].forEach({ view.addSubview($0) })
        
        setupDishImageViewConstraints()
        setupNameLabelConstraints()
        setupCaloriesLabelConstraints()
        setupDescriptionLabelConstraints()
        setupTextFieldConstraints()
        setupOrderButtonConstraints()
    }
    
    
    // MARK: - Constraints
    private func setupDishImageViewConstraints() {
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: view.topAnchor),
            dishImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dishImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dishImageView.heightAnchor.constraint(equalTo: dishImageView.widthAnchor)
        ])
    }
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupCaloriesLabelConstraints() {
        NSLayoutConstraint.activate([
            caloriesLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 16),
            caloriesLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            caloriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            caloriesLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupDescriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTextFieldConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupOrderButtonConstraints() {
        NSLayoutConstraint.activate([
            orderButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            orderButton.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            orderButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            orderButton.heightAnchor.constraint(equalTo: textField.heightAnchor)
        ])
    }
}
