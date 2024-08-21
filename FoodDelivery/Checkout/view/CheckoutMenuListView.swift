//
//  CheckoutMenuListView.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 19/08/24.
//

import UIKit

protocol CheckoutMenuListViewDelegate: AnyObject {
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int)
    func onIncrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int)
    func onDecrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int)
}

class CheckoutMenuListView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    weak var delegate: CheckoutMenuListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenuOrderList(menuOrderList: [MenuOrder]) {
        titleLabel.text = menuOrderList.first?.menu.name
        
        for (index, menuOrder) in menuOrderList.enumerated() {
            let view: MenuOrderView = MenuOrderView(frame: .zero)
            view.tag = index
            view.delegate = self
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setupMenuOrder(menuOrder: menuOrder)
            stackView.addArrangedSubview(view)
        }
    }
}

private extension CheckoutMenuListView {
    func setupView() {
        addSubview(titleLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension CheckoutMenuListView: MenuOrderViewDelegate {
    func onEditButtonDidTapped(index: Int) {
        delegate?.onEditButtonDidTapped(orderIndex: index, menuIndex: tag)
    }
    
    func onIncrementMenuQtyBtnDidTapped(index: Int, qty: Int) {
        delegate?.onIncrementMenuQtyBtnDidTapped(qty: qty, orderIndex: index, menuIndex: tag)
    }
    
    func onDecrementMenuQtyBtnDidTapped(index: Int, qty: Int) {
        delegate?.onDecrementMenuQtyBtnDidTapped(qty: qty, orderIndex: index, menuIndex: tag)
    }
}
