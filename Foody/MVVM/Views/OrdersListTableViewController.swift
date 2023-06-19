//
//  OrdersListTableViewController.swift
//  Foody
//
//  Created by Khater on 5/15/23.
//

import UIKit
import SkeletonView


class OrdersListTableViewController: UITableViewController {
    
    
    // MARK: - Variables
    private let viewModel = OrderListViewModel()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Naviagation
        navigationItem.title = "Orders"
        
        // TableView
        tableView.separatorStyle = .none
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        
        // ViewModel
        viewModel.viewDidLoad()
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource
extension OrdersListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.showNoOrdersMessage {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No orders yet!"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
            
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
            if let order = viewModel.rowAt(indexPath) {
                cell.setup(order)
            }
            return cell
        }
    }
}


// MARK: - UITableViewDelegate
extension OrdersListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath) { [weak self] vc in
            self?.present(vc, animated: true)
        }
    }
}
