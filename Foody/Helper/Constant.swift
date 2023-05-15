//
//  Constant.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit

struct Constant {
    static let defaultImage = UIImage(named: "appIcon")
    
    static let collectionViewSectionHeaderView = (TitleHeaderCollectionReusableView.self, UICollectionView.elementKindSectionHeader, TitleHeaderCollectionReusableView.identifier)
    
    static func collectionViewLayoutHeader(_ pin: Bool = false) ->  NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = pin
        return header
    }
}
