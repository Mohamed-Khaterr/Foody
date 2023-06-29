//
//  CreateOrderView.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import UIKit


@objc protocol CreateOrderViewDelegate: AnyObject {
    func orderButtonPressed()
    func plusButtonPressed()
    func minusButtonPressed()
}


class CreateOrderView: UIView {
    
    // MARK: - UIComponents
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setImage("https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg")
        return imageView
    }()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teriyaki Chicken Casserole"
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.cornerRadius = 5
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.backgroundColor = .clear
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 5
        button.setTitle("+", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.backgroundColor = .clear
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 5
        button.setTitle("-", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Your username.."
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.layer.borderWidth = 0.1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftView = padding
        textField.leftViewMode = .always
        return textField
    }()
    
    private let orderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Order", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Subviews Layout
    private func setupSubviewsLayout() {
        [mealImageView, mealNameLabel, quantityStackView, usernameTextField, orderButton].forEach({ addSubview($0) })
        [plusButton, quantityLabel, minusButton].forEach({ quantityStackView.addArrangedSubview($0) })
        
        setupMealImageViewConstraints()
        setupMealNameLabelConstraints()
        setupQuantityStackView()
        setupUsernameTextFieldConstraints()
        setupOrderButtonConstraints()
    }
    
    private func setupMealImageViewConstraints() {
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            mealImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            mealImageView.heightAnchor.constraint(equalToConstant: 160),
            mealImageView.widthAnchor.constraint(equalTo: mealImageView.heightAnchor)
        ])
    }
    
    private func setupMealNameLabelConstraints() {
        NSLayoutConstraint.activate([
            mealNameLabel.topAnchor.constraint(equalTo: mealImageView.topAnchor, constant: 16),
            mealNameLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 16),
            mealNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupQuantityStackView() {
        NSLayoutConstraint.activate([
            quantityStackView.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 24),
            quantityStackView.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 24),
            quantityStackView.heightAnchor.constraint(equalToConstant: 40),
            quantityStackView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupUsernameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 24),
            usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        ])
    }
    
    private func setupOrderButtonConstraints() {
        NSLayoutConstraint.activate([
            orderButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 24),
            orderButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            orderButton.heightAnchor.constraint(equalToConstant: 50),
            orderButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    
    
    // MARK: - Setters
    public weak var delegate: CreateOrderViewDelegate? {
        didSet {
            orderButton.addTarget(delegate, action: #selector(delegate?.orderButtonPressed), for: .touchUpInside)
            plusButton.addTarget(delegate, action: #selector(delegate?.plusButtonPressed), for: .touchUpInside)
            minusButton.addTarget(delegate, action: #selector(delegate?.minusButtonPressed), for: .touchUpInside)
        }
    }
    
    public weak var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            usernameTextField.delegate = textFieldDelegate
        }
    }
    
    public var username: String? {
        return usernameTextField.text
    }
    
    public var quantity: String? {
        didSet {
            quantityLabel.text = quantity
        }
    }
    
    public var name: String? = nil {
        didSet {
            mealNameLabel.text = name
        }
    }
    
    public var image: String = "" {
        didSet {
            mealImageView.setImage(image)
        }
    }
    
    public var isElementsEnabled: Bool = true {
        didSet {
            orderButton.isEnabled = isElementsEnabled
            plusButton.isEnabled = isElementsEnabled
            minusButton.isEnabled = isElementsEnabled
            usernameTextField.isEnabled = isElementsEnabled
        }
    }
}
