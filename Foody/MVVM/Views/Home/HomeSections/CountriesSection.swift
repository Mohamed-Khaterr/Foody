//
//  CountriesSection.swift
//  Foody
//
//  Created by Khater on 6/21/23.
//

import UIKit
import Combine



class CountriesSection: UICollectionView {
    
    // MARK: - Variables
    var navigationControllerPushVC: ((UIViewController) -> Void)? // from HomeCollectionViewControllerSection
    var presentVC: ((UIViewController) -> Void)? // from HomeCollectionViewControllerSection
    
    private let viewModel = CountriesViewModel()
    private var viewModelSubscriber: AnyCancellable?
    private let inputPublisher: PassthroughSubject<CountriesViewModel.Input, Never> = .init()
    
    
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
extension CountriesSection: HomeCollectionViewControllerSection {
    var view: UIView { self }
    
    var sectionHeight: CGFloat {
        return 60.0
    }
    
    var sectionTitle: String {
        return "Countries"
    }
    
    func sectionHeaderButtonTapped() {
        navigationControllerPushVC?(CountriesCollectionViewController())
    }
    
    func viewDidLoad() {
        configurarCollectionView()
        bindViewModel()
        inputPublisher.send(.viewDidLoad)
        inputPublisher.send(.limitCountries(true))
    }
    
    private func configurarCollectionView() {
        // Appearnce
        showsHorizontalScrollIndicator = false
        
        // Register Cell
        register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: CountryCollectionViewCell.identifier)
        
        // Set the protocols
        delegate = self
        dataSource = self
    }
    
    private func bindViewModel() {
        viewModelSubscriber = viewModel.bind(input: inputPublisher.eraseToAnyPublisher())
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .reloadData:
                    self.reloadData()
                    
                case .navigateToCountryMeals(let vc):
                    self.navigationControllerPushVC?(vc)
                    
                case .errorOccur(title: let title, message: let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.presentVC?(alert)
                }
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
        cell.skeletonView(viewModel.isAnimating)
        let country = viewModel.itemForCell(at: indexPath)
        cell.setCountry(country)
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension CountriesSection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputPublisher.send(.selectContryAt(indexPath))
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
