//
//  FoodCategoriesCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import UIKit
import Combine


class FoodCategoriesCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    private let viewModel = FoodCategoriesViewModel()
    private let inputPublisher: PassthroughSubject<FoodCategoriesInput, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    
    // MARK: - init
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: FoodCategoriesCollectionViewController")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Navigation
        navigationItem.title = "All Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Register Cells
        collectionView.register(FoodCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FoodCategoryCollectionViewCell.identifier)
        
        bind()
        inputPublisher.send(.viewDidLoad)
    }
    
    private func bind() {
        viewModel.bind(ViewInput: inputPublisher.eraseToAnyPublisher())
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .reloadData:
                    self.collectionView.reloadData()
                    
                case .error(let title, let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert, animated: true)
                    
                case .navigateToCategoryMeals(let mealsVC):
                    self.navigationController?.pushViewController(mealsVC, animated: true)
                }
            }
            .store(in: &cancellable)
    }
}



// MARK: - UICollectionViewDataSource
extension FoodCategoriesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.identifier, for: indexPath) as! FoodCategoryCollectionViewCell
        cell.skeletonView(viewModel.isAnimating)
        let category = viewModel.itemForCell(at: indexPath)
        cell.setFoodCategory(category)
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension FoodCategoriesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputPublisher.send(.didSelectItemAt(indexPath))
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
