//
//  CreateOrderViewController.swift
//  Foody
//
//  Created by Khater on 6/14/23.
//

import UIKit
import Combine


class CreateOrderViewController: UIViewController {
    
    
    // MARK: - Variables
    private let mainView = CreateOrderView()
    private let viewModel: CreateOrderViewModel
    private let inputPublisher: PassthroughSubject<CreateOrderViewModel.Input, Never> = .init()
    private var cancelllable = Set<AnyCancellable>()
    
    
    init(meal: MealDetails) {
        viewModel = CreateOrderViewModel(mealDetails: meal)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: CreateOrderViewController")
    }
    
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMainView()
        bind()
        inputPublisher.send(.viewDidLoad)
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonPressed))
        cancelButton.tintColor = .red
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.title = "Create Order"
    }
    
    private func setupMainView() {
        mainView.textFieldDelegate = self
        mainView.delegate = self
    }
    
    private func bind() {
        viewModel.bind(input: inputPublisher.eraseToAnyPublisher())
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .updateQuantityLabel(let text):
                    self.mainView.quantity = text
                    
                case .updateElements(let name, let image, let quantity):
                    self.mainView.name = name
                    self.mainView.image = image
                    self.mainView.quantity = quantity
                    
                case .elementsEnable(let isEnabled):
                    self.mainView.isElementsEnabled = isEnabled
                    
                case .alert(let title, let message, let dismissVCOnAction):
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                        guard let self2 = self else { return }
                        if dismissVCOnAction {
                            self2.dismiss(animated: true)
                        }
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            .store(in: &cancelllable)
    }
    
    
    
    // MARK: - Buttons Action
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true)
    }
}




// MARK: - UITextFieldDelegate
extension CreateOrderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputPublisher.send(.usernametextFieldReturnButtonPressed(mainView.username))
        textField.endEditing(true)
        return true
    }
}



// MARK: - CreateOrderViewDelegate
extension CreateOrderViewController: CreateOrderViewDelegate {
    func orderButtonPressed() {
        inputPublisher.send(.usernametextFieldReturnButtonPressed(mainView.username))
        inputPublisher.send(.orderButtonPressed)
    }

    func plusButtonPressed() {
        inputPublisher.send(.plusButtonPressed)
    }

    func minusButtonPressed() {
        inputPublisher.send(.minusButtonPressed)
    }
}
