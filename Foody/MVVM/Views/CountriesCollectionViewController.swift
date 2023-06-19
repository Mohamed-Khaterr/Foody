//
//  CountriesCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/18/23.
//

import UIKit


class CountriesCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    private let viewModel = CountriesViewModel()
    
    
    
    
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
        navigationItem.title = "Countries"
        
        // Register cell classes
        self.collectionView!.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: CountryCollectionViewCell.identifier)
        
        
        // Setup ViewModle
        viewModel.fetchCountries()
        viewModel.reloadData = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}



// MARK: - UICollectionViewDataSource
extension CountriesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell
        cell.skeletonView(show: viewModel.isSkeletonAnimating)
        if let country = viewModel.itemAt(indexPath) {
            cell.setValues(country)
        }
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension CountriesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath) { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
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
