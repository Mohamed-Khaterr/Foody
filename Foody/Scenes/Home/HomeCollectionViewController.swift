//
//  HomeCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/12/23.
//

import UIKit
import Combine


/// HomeCollectionViewController is a CollectionViewController which consists of  collectionView sections + last section,
/// Each Section is subview of main collectionViewCell expet last section (bottom section),
/// Each section has it's own Delegate and Datasource,
/// Sections comfrim to HomeCollectionViewControllerSection protocol which makes HomeCollectionViewController notify each section when viewDidLoad.
/// Also each section has it's own ViewModel
class HomeCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    // Top section
    private var sections = [HomeCollectionViewControllerSection]()
    
    
    // ViewModel for last section
    private let mealsViewModel = MealsViewModel(type: .country("Canadian"))
    private let mealsInputPublisher: PassthroughSubject<MealsInput, Never> = .init()
    private var mealsSubscriber: AnyCancellable?
    // Last Section Index
    private var lastSection: Int {
        return sections.count
    }
    
    
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
        view.backgroundColor = .white
        setupNavigationController()
        registerCellInCollectionView()
        setupSections()
        bindWithMealsViewModel()
        mealsInputPublisher.send(.viewDidLoad)
    }
    
    
    
    
    // MARK: - Functions
    private func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .done, target: self, action: #selector(cartBarButtonPressed))
        cartButton.tintColor = .red
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchBarButtonPressed))
        navigationItem.rightBarButtonItems = [cartButton, searchButton]
    }
    
    private func registerCellInCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(HeaderTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleCollectionReusableView.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SectionCell")
        collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: MealCollectionViewCell.identifier)
    }
    
    private func setupSections() {
        sections = [CountriesSection(), FoodCategoriesSection()]
        
        for (index, section) in sections.enumerated() {
            // notify each section when viewDidLoad
            section.viewDidLoad()
            
            sections[index].navigationControllerPushVC = { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            sections[index].presentVC = { [weak self] vc in
                self?.present(vc, animated: true)
            }
        }
    }
    
    private func bindWithMealsViewModel() {
        mealsSubscriber = mealsViewModel.bind(input: mealsInputPublisher.eraseToAnyPublisher())
            .sink { [weak self] events in
                guard let self = self else { return }
                switch events {
                case .reloadData:
                    self.collectionView.reloadSections(IndexSet(integer: self.lastSection))
                    
                case .error(title: let title, message: let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert, animated: true)
                    
                case .goToMealDetailsVC(let mealDetailsVC):
                    self.navigationController?.pushViewController(mealDetailsVC, animated: true)
                }
            }
    }
    
    
    
    // MARK: - NavigationItem Bar Buttons
    @objc private func cartBarButtonPressed() {
        navigationController?.pushViewController(CartTableViewController(), animated: true)
    }
    
    @objc private func searchBarButtonPressed() {
        let searchVC = SearchCollectionViewController()
        let nav = UINavigationController(rootViewController: searchVC)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
    }
}



// MARK: - UICollectionViewDataSource
extension HomeCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // +1 is for last section which is Meals Section
        return sections.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == lastSection {
            // Last section
            return mealsViewModel.numberOfItems
        } else  {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == lastSection {
            // Last section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.identifier, for: indexPath) as! MealCollectionViewCell
            cell.skeletonView(show: mealsViewModel.isSkeletonAnimating)
            let meal = mealsViewModel.itemForCell(at: indexPath)
            cell.setMeal(meal)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath)
            let section = sections[indexPath.section]
            cell.contentView.addSubview(section.view)
            // Set Constraints of each section to the Cell
            setConstraints(superview: cell, subview: section.view)
            return cell
        }
    }
    
    private func setConstraints(superview: UIView, subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: superview.topAnchor),
            subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError()
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTitleCollectionReusableView.identifier, for: indexPath) as! HeaderTitleCollectionReusableView
        if indexPath.section == lastSection {
            headerView.setTitle("Meals")
            headerView.hideRightButton()
        } else {
            let section = sections[indexPath.section]
            headerView.setTitle(section.sectionTitle)
            headerView.rightButtonTapped = { [weak self] in
                self?.sections[indexPath.section].sectionHeaderButtonTapped()
            }
        }
        return headerView
    }
}


// MARK: - UICollectionViewDelegate
extension HomeCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == lastSection else { return }
        mealsInputPublisher.send(.didSelectItemAt(indexPath))
    }
}



// MARK: - UICollectionViewDelegateFlowLayout
extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == lastSection {
            return .init(top: 0, left: 8, bottom: 0, right: 8)
        } else {
            // No padding for other top sections
            return .init(top: 0, left: 0, bottom: 8, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == lastSection {
            return CGSize(width: 180, height: 200)
        } else {
            // For nested CollectionViews
            let section = sections[indexPath.section]
            return CGSize(width: view.frame.width, height: section.sectionHeight)
        }
    }
}
