//
//  CheckoutViewController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 19/08/24.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    private var viewModel: CheckoutViewModelProtocol
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var orderMenuStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var locationView: CheckoutLocationView = {
        let location: CheckoutLocationView = CheckoutLocationView(frame: .zero)
        location.translatesAutoresizingMaskIntoConstraints = false
        location.layer.borderWidth = 1
        location.layer.borderColor = UIColor.gray.cgColor
        
        return location
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Price"
        
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rp. 0"
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.setTitle("Complete Payment", for: .normal)
        btn.setTitleColor(UIColor(ciColor: .black), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 250)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(payButtonDidTapped), for: .touchUpInside)
        
        return btn
    }()
    
    init(viewModel: CheckoutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

private extension CheckoutViewController {
    @objc
    func payButtonDidTapped() {
        viewModel.onPayButtonDidTapped()
    }
}

extension CheckoutViewController: CheckoutViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        title = "Checkout"
        
        let bottomSeparator: UIView = UIView(frame: .zero)
        bottomSeparator.backgroundColor = .gray
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        view.addSubview(locationView)
        view.addSubview(totalPriceLabel)
        view.addSubview(priceLabel)
        view.addSubview(payButton)
        view.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            locationView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            locationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: totalPriceLabel.leadingAnchor, constant: -16),
            
            totalPriceLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalPriceLabel.widthAnchor.constraint(equalToConstant: 120),
            
            bottomSeparator.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            bottomSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            payButton.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 8),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        scrollView.addSubview(orderMenuStackView)
        
        NSLayoutConstraint.activate([
            orderMenuStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            orderMenuStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            orderMenuStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            orderMenuStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func updateOrderList(menuOrderList: [MenuOrder], index: Int) {
        let checkoutMenuListView: CheckoutMenuListView = CheckoutMenuListView(frame: .zero)
        checkoutMenuListView.setupMenuOrderList(menuOrderList: menuOrderList)
        checkoutMenuListView.translatesAutoresizingMaskIntoConstraints = false
        checkoutMenuListView.delegate = self
        checkoutMenuListView.tag = index
        orderMenuStackView.addArrangedSubview(checkoutMenuListView)
    }
    
    func setupTotalPrice(totalPriceString: String) {
        totalPriceLabel.text = totalPriceString
    }
    
    func presentDetailMenuModally(with menuOrder: MenuOrder) {
        let viewModel: MenuDetailViewModel = MenuDetailViewModel(menuOrder: menuOrder, isEditing: true)
        let viewController: MenuDetailViewController = MenuDetailViewController(viewModel: viewModel)
        viewModel.action = self

        viewController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6 )
        viewController.modalPresentationStyle = .pageSheet
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [
                .custom{ _ in UIScreen.main.bounds.height * 0.6 }
            ]
            
            sheet.prefersGrabberVisible = true
        }
            
        present(viewController, animated: true)
    }
    
    func resetStackView() {
        for arrangedSubview in orderMenuStackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
    }
}

extension CheckoutViewController: CheckoutMenuListViewDelegate {
    
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int) {
        viewModel.onEditButtonDidTapped(orderIndex: orderIndex, menuIndex: menuIndex)
    }
    
    func onIncrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int) {
        viewModel.onIncrementMenuQtyBtnDidTapped(qty: qty, orderIndex: orderIndex, menuIndex: menuIndex)
    }
    
    func onDecrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int) {
        viewModel.onDecrementMenuQtyBtnDidTapped(qty: qty, orderIndex: orderIndex, menuIndex: menuIndex)
    }
    
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension CheckoutViewController: MenuDetailViewModelAction {
    func onDismissModal() {
        viewModel.onDetailDismissModal()
    }
}
