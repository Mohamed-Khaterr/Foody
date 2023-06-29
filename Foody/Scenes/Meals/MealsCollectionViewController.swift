//
//  MealsCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import UIKit
import Combine


class MealsCollectionViewController: UICollectionViewController {

    private let viewModel: MealsViewModel
    private let inputPublisher: PassthroughSubject<MealsViewModel.Input, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    
    // MARK: - init
    init(in mealsType: MealsType) {
        viewModel = MealsViewModel(type: mealsType)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: MealsCollectionViewController")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Navigation
        navigationItem.title = "\(viewModel.mealsTypeName) Meals"
        
        
        // Register Cells
        self.collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: MealCollectionViewCell.identifier)
        
        
        bind()
        inputPublisher.send(.viewDidLoad)
    }
    
    private func bind() {
        viewModel.bind(input: inputPublisher.eraseToAnyPublisher())
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .reloadData:
                    self.collectionView.reloadData()
                    
                case .error(let title, let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert, animated: true)
                    
                case .goToMealDetailsVC(let mealDetailsVC):
                    self.navigationController?.pushViewController(mealDetailsVC, animated: true)
                }
            }
            .store(in: &cancellable)
    }
}


// MARK: - UICollectionViewDataSource
extension MealsCollectionViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.identifier, for: indexPath) as! MealCollectionViewCell
        cell.skeletonView(show: viewModel.isSkeletonAnimating)
        let meal = viewModel.itemForCell(at: indexPath)
        cell.setMeal(meal)
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension MealsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputPublisher.send(.didSelectItemAt(indexPath))
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
