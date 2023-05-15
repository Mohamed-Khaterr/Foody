//
//  FoodCategorySection.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit


class FoodCategorySection: NSObject, CollectionViewSection {
    var reloadSection: (() -> Void)?
    var reloadItemAt: (([Int]) -> Void)?
}



// MARK: - CollectionViewSectionConfiguration
extension FoodCategorySection {
    func sectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item])
        
        let header = Constant.collectionViewLayoutHeader()
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func regisertCells() -> [(cellClass: UICollectionViewCell.Type, identifier: String)] {
        return [(FoodCategoryCollectionViewCell.self, FoodCategoryCollectionViewCell.identifier)]
    }
    
    func regiserSupplementaryViews() -> [(viewClass: UICollectionReusableView.Type, kind: String, idenifier: String)] {
        return [(TitleHeaderCollectionReusableView.self, UICollectionView.elementKindSectionHeader, TitleHeaderCollectionReusableView.identifier)]
    }
}



// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FoodCategorySection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.identifier, for: indexPath) as! FoodCategoryCollectionViewCell
        cell.setup(.init(id: "1", name: "Beef", image: "https://www.themealdb.com/images/category/beef.png"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as! TitleHeaderCollectionReusableView
            view.setTitle("Food Category")
            return view
        }else {
            return UICollectionReusableView()
        }
    }
}
