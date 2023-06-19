//
//  MealsCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import UIKit


class MealsCollectionViewController: UICollectionViewController {

    private let viewModel = MealsViewModel()
    private let mealsType: MealsType
    
    // MARK: - init
    init(in mealsType: MealsType) {
        self.mealsType = mealsType
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
//        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "\(mealsType.value) Meals"
        
        
        // Register Cells
        self.collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: MealCollectionViewCell.identifier)
        
        
        // Setup ViewModel
        viewModel.fetchMeals(in: mealsType)
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}


// MARK: - UICollectionViewDataSource
extension MealsCollectionViewController{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.identifier, for: indexPath) as! MealCollectionViewCell
        cell.skeletonView(show: viewModel.isSkeletonAnimating)
        if let meal = viewModel.itemAt(indexPath){
            cell.setValues(meal)
        }
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension MealsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath) { [weak self] mealDetailsVC in
            self?.navigationController?.pushViewController(mealDetailsVC, animated: true)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MealsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 8)
    }
}
