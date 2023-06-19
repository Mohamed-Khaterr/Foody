//
//  CountriesSection.swift
//  Foody
//
//  Created by Khater on 6/12/23.
//

import UIKit



class CountriesSection: UICollectionView {
    
    // MARK: - Variables
    private let viewModel = CountriesViewModel()
    var pushViewController: ((UIViewController) -> Void)? // from HomeCollectionViewControllerSection
    
    
    // MARK: - init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        // Appearnce
        showsHorizontalScrollIndicator = false

        
        // Register Cell
        register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: CountryCollectionViewCell.identifier)
        
        
        // Set the protocols
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - HomeCollectionViewControllerSection
extension CountriesSection: HomeCollectionViewControllerSection {
    var view: UIView { self }
    
    var sectionHeight: CGFloat {
        return 60.0
    }
    
    var sectionTitle: String {
        return "Countries"
    }
    
    func viewDidLoad() {
        viewModel.fetchCountries()
        viewModel.reloadData = { [weak self] in
            self?.reloadData()
        }
    }
}



// MARK: - UICollectionViewDataSource
extension CountriesSection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell
        cell.skeletonView(show: viewModel.isSkeletonAnimating)
        if let country = viewModel.itemAt(indexPath) {
            cell.setValues(country)
        }
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension CountriesSection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath) { [weak self] mealsVC in
            self?.pushViewController?(mealsVC)
        }
    }
}



// MARK: - UICollectionViewDelegateFlowLayout
extension CountriesSection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 55)
    }
}
