//
//  CreateOrderViewController.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import UIKit

class CreateOrderViewController: UIViewController {
    
    
    // MARK: - Variables
    private let mainView = CreateOrderView()
    private let viewModel: CreateOrderViewModel
    
    
    init(meal: MealDetails) {
        viewModel = CreateOrderViewModel(mealDetails: meal)
        super.init(nibName: nil, bundle: nil)
        mainView.setValues(name: meal.name, image: meal.image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonPressed))
        cancelButton.tintColor = .red
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.title = "Create Order"
        
        mainView.textFieldDelegate = self
        mainView.delegate = self
        
        viewModel.updateQuantity = { [weak self] quantity in
            self?.mainView.quantity = quantity
        }
        
        viewModel.showLoadingView = { [weak self] isLoading in
            self?.mainView.isElementsEnabled = !isLoading
        }
        
        viewModel.orderStatus = { [weak self] success in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let alert: UIAlertController!
                if success {
                    alert = UIAlertController(title: "Success", message: "Order created successfully!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self] action in
                        guard let strongSelf2 = self else { return }
                        strongSelf2.dismiss(animated: true)
                    }
                    alert.addAction(action)
                }else {
                    alert = UIAlertController(title: "Fail", message: "Fail to create an order!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                }
                
                strongSelf.present(alert, animated: true)
            }
        }
    }
    
    
    
    // MARK: - Functions
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true)
    }
}




// MARK: - UITextFieldDelegate
extension CreateOrderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}



// MARK: - CreateOrderViewDelegate
extension CreateOrderViewController: CreateOrderViewDelegate {
    func orderButtonPressed() {
        viewModel.createOrder(userName: mainView.usernameText)
    }
    
    func addButtonPressed() {
        viewModel.increaseQuantity()
    }
    
    func removeButtonPressed() {
        viewModel.decreaseQuantity()
    }
}
