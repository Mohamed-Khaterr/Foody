//
//  CollectionViewSectionConfiguration.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit


typealias CollectionViewSection = CollectionViewSectionConfiguration & UICollectionViewDelegate & UICollectionViewDataSource


protocol CollectionViewSectionConfiguration {
    var reloadSection: (() -> Void)? { get set }
    var reloadItemAt: (([Int]) -> Void)? { get set }
    
    func sectionLayout() -> NSCollectionLayoutSection
    func regisertCells() -> [(cellClass: UICollectionViewCell.Type, identifier: String)]
    func regiserSupplementaryViews() -> [(viewClass: UICollectionReusableView.Type, kind: String, idenifier: String)]
    func viewDidLoad()
}


extension CollectionViewSectionConfiguration {
    func viewDidLoad(){}
    
    func regisertCells() -> [(cellClass: UICollectionViewCell.Type, identifier: String)] {
        return []
    }
    
    func regiserSupplementaryViews() -> [(viewClass: UICollectionReusableView.Type, kind: String, idenifier: String)] {
        return []
    }
}
