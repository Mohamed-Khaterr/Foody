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
    var navigationControllerPushVC: ((UIViewController) -> Void)? { get set }
    var presentVC: ((UIViewController) -> Void)? { get set }
    func sectionHeaderButtonTapped()
    func viewDidLoad()
}
