//
//  ChefSpecialSection.swift
//  Foody
//
//  Created by Khater on 5/14/23.
//

import UIKit


class ChefSpecialSection: NSObject, CollectionViewSection {
    var reloadSection: (() -> Void)?
    var reloadItemAt: (([Int]) -> Void)?
    
    
}



// MARK: - CollectionViewSectionConfiguration
extension ChefSpecialSection {
    func sectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item])
        
        let header = Constant.collectionViewLayoutHeader()
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func regisertCells() -> [(cellClass: UICollectionViewCell.Type, identifier: String)] {
        return [(DishLandscapeCollectionViewCell.self, DishLandscapeCollectionViewCell.identifier)]
    }
    
    func regiserSupplementaryViews() -> [(viewClass: UICollectionReusableView.Type, kind: String, idenifier: String)] {
        return [Constant.collectionViewSectionHeaderView]
    }
}



// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ChefSpecialSection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishLandscapeCollectionViewCell.identifier, for: indexPath) as! DishLandscapeCollectionViewCell
        cell.setup(.init(id: "1", name: "Dish Chef", description: "Chef's dish", image: "https://www.themealdb.com/images/media/meals/vssrtx1511557680.jpg"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as! TitleHeaderCollectionReusableView
            view.setTitle("Chef's Special")
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}
