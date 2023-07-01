//
//  CartTableViewController.swift
//  Foody
//
//  Created by Khater on 5/15/23.
//

import UIKit
import SkeletonView
import Combine


class CartTableViewController: UITableViewController {
    
    
    // MARK: - Variables
    private let viewModel = CartViewModel()
    private let inputPublisher: PassthroughSubject<CartInput, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    private var isFooterAppear = false
    
    
    deinit {
        print("deinit: CartTableViewController")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Naviagation
        navigationItem.title = "Cart"
        
        // TableView
        setupTableView()
        
        // ViewModel
        bind()
        inputPublisher.send(.viewDidLoad)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
    }
    
    private func bind() {
        viewModel.bind(input: inputPublisher.eraseToAnyPublisher())
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .reloadData:
                    self.tableView.reloadData()
                    
                case .noOrdersMessage(let isAppeare):
                    self.isFooterAppear = isAppeare
                    
                case .goToMealDetailsVC(let mealsDetailsVC):
                    let nav = UINavigationController(rootViewController: mealsDetailsVC)
                    self.present(nav, animated: true)
                }
            }
            .store(in: &cancellable)
    }
}


// MARK: - UITableViewDataSource
extension CartTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        let order = viewModel.rowForCell(at: indexPath)
        cell.setup(order)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard isFooterAppear else { return nil}
        let footerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .white
        let label = UILabel(frame: footerView.bounds)
        label.text = "Empty!"
        label.textAlignment = .center
        label.textColor = .black
        footerView.addSubview(label)
        return footerView
    }
}


// MARK: - UITableViewDelegate
extension CartTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputPublisher.send(.didSelectRowAt(indexPath))
    }
}
