//
//  OrderListViewController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 06/08/24.
//

import UIKit

class OrderListViewController: UIViewController {
    
    let viewModel: OrderDetailViewModelProtocol
    
    private lazy var menuTitleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var menuOrderScrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var addAnoterToCartButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.setTitle("Add Another To Cart", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 255)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(addToCartBtnDidTapped), for: .touchUpInside)
        
        return btn
    }()

    init(viewModel: OrderDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    @objc
    func addToCartBtnDidTapped() {
        viewModel.onAddToCartBtnDidTapped()
    }
}

extension OrderListViewController: OrderDetailViewModelDelegate {
    
    func setupView(with menuDataList: [MenuOrder]) {
        view.backgroundColor = .white
        
        let topSeparator: UIView = UIView(frame: .zero)
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.backgroundColor = .gray
        
        let bottomSeparator: UIView = UIView(frame: .zero)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.backgroundColor = .gray
        
        view.addSubview(menuTitleLabel)
        view.addSubview(topSeparator)
        view.addSubview(menuOrderScrollView)
        view.addSubview(bottomSeparator)
        view.addSubview(addAnoterToCartButton)
        
        NSLayoutConstraint.activate([
            menuTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            menuTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            topSeparator.topAnchor.constraint(equalTo: menuTitleLabel.bottomAnchor, constant: 16),
            topSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            menuOrderScrollView.topAnchor.constraint(equalTo: topSeparator.bottomAnchor),
            menuOrderScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuOrderScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomSeparator.topAnchor.constraint(equalTo: menuOrderScrollView.bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),

            addAnoterToCartButton.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 16),
            addAnoterToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addAnoterToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addAnoterToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16 )
        ])
        
        setupOrderView(with: menuDataList)
    }
    
    func setupOrderView(with menuDataList: [MenuOrder]) {
        let menuListStackView: UIStackView = UIStackView(frame: .zero)
        menuListStackView.axis = .vertical
        menuListStackView.translatesAutoresizingMaskIntoConstraints = false
        menuOrderScrollView.addSubview(menuListStackView)
        
        NSLayoutConstraint.activate([
            menuListStackView.topAnchor.constraint(equalTo: menuOrderScrollView.topAnchor),
            menuListStackView.leadingAnchor.constraint(equalTo: menuOrderScrollView.leadingAnchor),
            menuListStackView.trailingAnchor.constraint(equalTo: menuOrderScrollView.trailingAnchor),
            menuListStackView.bottomAnchor.constraint(equalTo: menuOrderScrollView.bottomAnchor)
        ])
        
        for (index, menu) in menuDataList.enumerated() {
            let menuOrderView: MenuOrderView = MenuOrderView(frame: .zero)
            menuOrderView.delegate = self
            menuOrderView.tag = index
            menuOrderView.translatesAutoresizingMaskIntoConstraints = false
            menuOrderView.setupMenuOrder(menuOrder: menu)
            menuListStackView.addArrangedSubview(menuOrderView)
        }
        
        menuTitleLabel.text = menuDataList[0].menu.name
    }
    
    func dismissModal(completion: @escaping () -> Void) {
        dismiss(animated: true, completion: completion)
    }
    
}

extension OrderListViewController: MenuOrderViewDelegate {
    func onIncrementMenuQtyBtnDidTapped(index: Int, qty: Int) {
        viewModel.onDidQtyIncressedBtnDidTapped(index: index, qty: qty)
    }
    
    func onDecrementMenuQtyBtnDidTapped(index: Int, qty: Int) {
        viewModel.onDidQtyDecresedBtnDidTapped(index: index, qty: qty)
    }
    
    func onEditButtonDidTapped(index: Int) {
        viewModel.onEditButtonDidTapped(index: index)
    }
    
    func dismiss(completion: @escaping () -> Void) {
        
    }
}
