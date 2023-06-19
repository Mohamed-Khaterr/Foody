//
//  CountryCollectionViewCell.swift
//  Foody
//
//  Created by Khater on 6/5/23.
//

import UIKit
import SkeletonView


final class CountryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CountryCollectionViewCell"
    
    // MARK: - UIComponents
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Country"
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Functions
    private func setupView() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        clipsToBounds = true
        isSkeletonable = true
        
        addSubview(countryNameLabel)
        setupCountryNameLabelConstraints()
    }
    
    private func setupCountryNameLabelConstraints() {
        NSLayoutConstraint.activate([
            countryNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func setValues(_ country: Country) {
        countryNameLabel.text = country.name
    }
    
    public func skeletonView(show: Bool) {
        if show {
            showAnimatedGradientSkeleton()
        } else {
            hideSkeleton()
        }
    }
}
