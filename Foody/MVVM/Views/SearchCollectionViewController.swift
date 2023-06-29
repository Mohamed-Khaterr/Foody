//
//  SearchCollectionViewController.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import UIKit
import Combine


class SearchCollectionViewController: UICollectionViewController {
    
    
    // MARK: - UIComponents
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search..."
        sb.searchTextField.addTarget(self, action: #selector(searchBarTextChange), for: .editingChanged)
        sb.searchTextField.addTarget(self, action: #selector(searchBarSearchButtonPressed), for: .primaryActionTriggered)
        return sb
    }()
    
    
    
    
    
    // MARK: - Variables
    private let footerReuseIdentifier = "footerViewCell"
    private var isCollectionViewFooterAppear = false
    private let viewModel = SearchViewModel()
    private let inputPublisher: PassthroughSubject<SearchViewModel.Input, Never> = .init()
    private var outputSubscirber: AnyCancellable?
    
    
    
    // MARK: - init
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 180, height: 200)
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 8.0
        flowLayout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: SearchCollectionViewController")
    }
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        bindWithViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
    
    
    // MARK: - Functions
    private func setupNavigationBar() {
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelBarButtonPressed))
        navigationItem.rightBarButtonItem = cancelBarButton
        navigationItem.titleView = searchBar
    }
    
    private func setupCollectionView() {
        // Register cell classes
        self.collectionView!.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: MealCollectionViewCell.identifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
    }
    
    private func bindWithViewModel() {
        outputSubscirber = viewModel.bind(input: inputPublisher.eraseToAnyPublisher())
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .reloadData:
                    self.collectionView.reloadData()
                    
                case .footerAppear(let isAppear):
                    self.isCollectionViewFooterAppear = isAppear
                
                case .goToMealDetailsVC(let mealDetailsVC):
                    self.navigationController?.pushViewController(mealDetailsVC, animated: true)
                    
                case .error(let title, let message):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert, animated: true)
                    
                }
            }
    }
    
    
    // MARK: - NavigationItem Bar Buttons
    @objc private func cancelBarButtonPressed() {
        dismiss(animated: true)
    }
    
    // MARK: - SeachBar Actions
    @objc private func searchBarTextChange() {
        guard let text = searchBar.text else { return }
        inputPublisher.send(.searchTextFieldDidChange(text))
    }
    
    @objc private func searchBarSearchButtonPressed() {
        searchBar.endEditing(true)
    }
}



// MARK: - UICollectionViewDataSource
extension SearchCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.identifier, for: indexPath) as! MealCollectionViewCell
        cell.skeletonView(show: viewModel.isItemAnimating)
        let meal = viewModel.itemForCell(at: indexPath)
        cell.setMeal(meal)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError()
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath)
        let textLabel = UILabel(frame: footerView.bounds)
        textLabel.text = "No result"
        textLabel.textAlignment = .center
        footerView.addSubview(textLabel)
        return footerView
    }
}



// MARK: UICollectionViewDelegate
extension SearchCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputPublisher.send(.didSelectItemAt(indexPath))
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isCollectionViewFooterAppear ? CGSize(width: collectionView.frame.width, height: 44) : .zero
    }
}
