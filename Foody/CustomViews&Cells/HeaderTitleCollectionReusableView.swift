//
//  HeaderTitleCollectionReusableView.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit

class HeaderTitleCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Section title"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let rightArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See More", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        return button
    }()
    
    public var rightButtonTapped: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        // Add subviews
        [titleLabel, rightArrowButton].forEach({ addSubview($0) })
        
        // Set Constraints
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            // Right Arrow Button
            rightArrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrowButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -18),
        ])
        
        rightArrowButton.addTarget(self, action: #selector(rightArrowButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func rightArrowButtonPressed() {
        rightButtonTapped?()
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func hideRightButton() {
        rightArrowButton.isHidden = true
    }
}
