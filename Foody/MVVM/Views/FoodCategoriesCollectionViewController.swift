//
//  FoodCategoriesCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import UIKit

class FoodCategoriesCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    private let viewModel = FoodCategoriesViewModel()
    
    
    // MARK: - init
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Navigation
        navigationItem.title = "All Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Register Cells
        collectionView.register(FoodCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FoodCategoryCollectionViewCell.identifier)
        
        
        // Setup ViewModel
        viewModel.fetchFoodCategories()
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}



// MARK: - UICollectionViewDataSource
extension FoodCategoriesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.identifier, for: indexPath) as! FoodCategoryCollectionViewCell
        cell.skeletonView(show: viewModel.isSkeletonAnimating)
        if let category = viewModel.itemAt(indexPath) {
            cell.setValues(category)
        }
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension FoodCategoriesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath) { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}




// MARK: - UICollectionViewDelegateFlowLayout
extension FoodCategoriesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
}
