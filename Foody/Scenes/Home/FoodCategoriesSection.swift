//
//  FoodCategoriesSection.swift
//  Foody
//
//  Created by Khater on 6/13/23.
//

import UIKit
import Combine



final class FoodCategoriesSection: UICollectionView {
    
    // From HomeCollectionViewControllerSection
    var navigationControllerPushVC: ((UIViewController) -> Void)?
    var presentVC: ((UIViewController) -> Void)?
    
    
    // MARK: - Variables
    private let viewModel = FoodCategoriesViewModel()
    private let inputPublisher: PassthroughSubject<FoodCategoriesInput, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    
    // MARK: - init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
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
    
    func sectionHeaderButtonTapped() {
        navigationControllerPushVC?(FoodCategoriesCollectionViewController())
    }
    
    func viewDidLoad() {
        configurarCollectionView()
        bind()
        inputPublisher.send(.viewDidLoad)
        inputPublisher.send(.limitItems(true))
    }
    
    private func configurarCollectionView() {
        // Register Cell
        register(FoodCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FoodCategoryCollectionViewCell.identifier)
        
        // Set the protocols
        delegate = self
        dataSource = self
        
        // Appearnce
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        clipsToBounds = false // To Make shadow of CardView in Cell appear
    }
    
    private func bind() {
        viewModel.bind(ViewInput: inputPublisher.eraseToAnyPublisher())
            .sink { [weak self] output in
                switch output {
                case .reloadData:
                    self?.reloadData()
                    
                case .error(let title, let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self?.presentVC?(alert)
                    
                case .navigateToCategoryMeals(let mealsVC):
                    self?.navigationControllerPushVC?(mealsVC)
                }
            }
            .store(in: &cancellable)
    }
}



// MARK: - UICollectionViewDataSource
extension FoodCategoriesSection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.identifier, for: indexPath) as! FoodCategoryCollectionViewCell
        cell.skeletonView(viewModel.isAnimating)
        let category = viewModel.itemForCell(at: indexPath)
        cell.setFoodCategory(category)
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension FoodCategoriesSection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputPublisher.send(.didSelectItemAt(indexPath))
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
