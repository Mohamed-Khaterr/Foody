//
//  CountriesCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import UIKit
import Combine


class CountriesCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    private let viewModel = CountriesViewModel()
    private var cancellable = Set<AnyCancellable>()
    private let inputPublisher: PassthroughSubject<CountriesInput, Never> = .init()
    
    
    
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
        print("deinit: CountriesCollectionViewController")
    }
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Navigation
        navigationItem.title = "Countries"
        
        // Register cell classes
        self.collectionView!.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: CountryCollectionViewCell.identifier)
        
        
        // Setup ViewModle
        bind()
        inputPublisher.send(.viewDidLoad)
    }
    
    private func bind() {
        viewModel.bind(input: inputPublisher.eraseToAnyPublisher())
            .sink { [unowned self] events in
                switch events {
                case .reloadData:
                    self.collectionView.reloadData()
                    
                case .navigateToCountryMeals(let vc):
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .errorOccur(title: let title, message: let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
            .store(in: &cancellable)
    }
}



// MARK: - UICollectionViewDataSource
extension CountriesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell
        let country = viewModel.itemForCell(at: indexPath)
        cell.setCountry(country)
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension CountriesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputPublisher.send(.selectContryAt(indexPath))
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CountriesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.45, height: 55)
    }
}
