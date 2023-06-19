//
//  FoodCategoriesSection.swift
//  Foody
//
//  Created by Khater on 6/13/23.
//

import UIKit



class FoodCategoriesSection: UICollectionView {
    
    // MARK: - Variables
    private let viewModel = FoodCategoriesViewModel()
    var pushViewController: ((UIViewController) -> Void)? // from HomeCollectionViewControllerSection
    
    
    
    // MARK: - init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        // Appearnce
        showsHorizontalScrollIndicator = false
        clipsToBounds = false // To Make shadow of CardView in Cell appear
        
        
        // Register Cell
        register(FoodCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FoodCategoryCollectionViewCell.identifier)
        
        
        // Set the protocols
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - HomeCollectionViewControllerSection
extension FoodCategoriesSection: HomeCollectionViewControllerSection {
    var view: UIView { self }
    
    var sectionHeight: CGFloat {
        return 130.0
    }
    
    var sectionTitle: String {
        return "Food Categories"
    }
    
    func viewDidLoad() {
        viewModel.fetchFoodCategories()
        viewModel.reloadData = { [weak self] in
            self?.reloadData()
        }
    }
}



// MARK: - UICollectionViewDataSource
extension FoodCategoriesSection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.identifier, for: indexPath) as! FoodCategoryCollectionViewCell
        cell.skeletonView(show: viewModel.isSkeletonAnimating)
        if let category = viewModel.itemAt(indexPath) {
            cell.setValues(category)
        }
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension FoodCategoriesSection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath) { [weak self] vc in
            self?.pushViewController?(vc)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension FoodCategoriesSection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 16)
    }
}
