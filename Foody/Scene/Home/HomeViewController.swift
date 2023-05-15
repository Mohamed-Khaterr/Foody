//
//  HomeViewController.swift
//  Foody
//
//  Created by Khater on 5/12/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    // MARK: - UIComponents
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    // MARK: - Variables
    private var sections = [CollectionViewSection]()
    
    
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        setupSections()
        sections.forEach({ $0.viewDidLoad() })
    }
    
    
    // MARK: - Functions
    private func setupNavigation() {
        navigationItem.title = "Foody"
        
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: nil)
        cartButton.tintColor = .red
        navigationItem.rightBarButtonItem = cartButton
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { index, env in
            return self.sections[index].sectionLayout()
        }, configuration: config)
    }
    
    
    private func setupSections() {
        // Sections Sequence
        sections = [
            FoodCategorySection(),
            PopularDishesSection(),
            ChefSpecialSection()
        ]
        
        for index in sections.indices {
            // Reload Section
            sections[index].reloadSection = { [weak self] in
                guard let strongeSelf = self else { return }
                let indexSet = IndexSet(integer: index)
                strongeSelf.collectionView.reloadSections(indexSet)
            }
            
            
            // Reload Item For Section
            sections[index].reloadItemAt = { [weak self] itemIndex in
                guard let strongeSelf = self else { return }
                let indexPaths = itemIndex.compactMap({ IndexPath(item: $0, section: index)})
                strongeSelf.collectionView.reloadItems(at: indexPaths)
            }
            
            // Register Cells
            let cells = sections[index].regisertCells()
            for cell in cells {
                collectionView.register(cell.cellClass, forCellWithReuseIdentifier: cell.identifier)
            }
            
            
            // Register SupplementryViews
            let reusableViews = sections[index].regiserSupplementaryViews()
            for reusableView in reusableViews {
                collectionView.register(reusableView.viewClass, forSupplementaryViewOfKind: reusableView.kind, withReuseIdentifier: reusableView.idenifier)
            }
        }
    }
    
}



// MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView = sections[indexPath.section].collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) else {
            fatalError("Can't reuse view")
        }
        return reusableView
    }
}
