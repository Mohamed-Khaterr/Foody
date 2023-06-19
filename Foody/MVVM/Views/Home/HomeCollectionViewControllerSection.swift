//
//  HomeCollectionViewControllerSection.swift
//  Foody
//
//  Created by Khater on 6/13/23.
//

import UIKit


protocol HomeCollectionViewControllerSection {
    var view: UIView { get }
    var sectionHeight: CGFloat { get }
    var sectionTitle: String { get }
    var pushViewController: ((UIViewController) -> Void)? { get set }
    func viewDidLoad()
}
