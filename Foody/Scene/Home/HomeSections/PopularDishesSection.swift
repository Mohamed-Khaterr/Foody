//
//  PopularDishesSection.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit


class PopularDishesSection: NSObject, CollectionViewSection {
    var reloadSection: (() -> Void)?
    var reloadItemAt: (([Int]) -> Void)?
    
    
}


// MARK: - CollectionViewSectionConfiguration
extension PopularDishesSection {
    func sectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(260), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let header = Constant.collectionViewLayoutHeader()

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func regisertCells() -> [(cellClass: UICollectionViewCell.Type, identifier: String)] {
        return [(DishPortraitCollectionViewCell.self, DishPortraitCollectionViewCell.identifier)]
    }
    
    func regiserSupplementaryViews() -> [(viewClass: UICollectionReusableView.Type, kind: String, idenifier: String)] {
        return [(TitleHeaderCollectionReusableView.self, UICollectionView.elementKindSectionHeader, TitleHeaderCollectionReusableView.identifier)]
    }
}



// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PopularDishesSection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishPortraitCollectionViewCell.identifier, for: indexPath) as! DishPortraitCollectionViewCell
        cell.setup(.init(id: "1", name: "Dish", description: "This is good dish", image: "https://www.themealdb.com/images/media/meals/vssrtx1511557680.jpg"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as! TitleHeaderCollectionReusableView
            view.setTitle("Popular Dishes")
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}
