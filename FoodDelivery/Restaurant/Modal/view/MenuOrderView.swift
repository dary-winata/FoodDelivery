//
//  MenuOrderView.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 06/08/24.
//

import UIKit

protocol MenuOrderViewDelegate: AnyObject {
    func onEditButtonDidTapped(index: Int)
    func onIncrementMenuQtyBtnDidTapped(index: Int, qty: Int)
    func onDecrementMenuQtyBtnDidTapped(index: Int, qty: Int)
}

class MenuOrderView: UIView {
    
    weak var delegate: MenuOrderViewDelegate?
    
    private lazy var notesTitleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Notes: "
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var priceMenuLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var editMenuButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonDidTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var menuQtyStepper: MenuQtyStepperView = {
        let menuQty: MenuQtyStepperView = MenuQtyStepperView(frame: .zero)
        menuQty.translatesAutoresizingMaskIntoConstraints = false
        menuQty.delegate = self
        
        return menuQty
    }()
    
    private var menuOrder: MenuOrder?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuOrderView {
    func setupMenuOrder(menuOrder: MenuOrder) {
        self.menuOrder = menuOrder
        notesLabel.text = menuOrder.notes
        priceMenuLabel.text = "Rp. \(menuOrder.menu.price * Float(menuOrder.qty))"
        menuQtyStepper.currentQty = menuOrder.qty
    }
}

private extension MenuOrderView {
    func setupView() {
        addSubview(notesTitleLabel)
        addSubview(notesLabel)
        addSubview(priceMenuLabel)
        addSubview(editMenuButton)
        addSubview(menuQtyStepper)
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        
        NSLayoutConstraint.activate([
            notesTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            notesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            notesLabel.topAnchor.constraint(equalTo: notesTitleLabel.topAnchor),
            notesLabel.leadingAnchor.constraint(equalTo: notesTitleLabel.trailingAnchor),
            
            priceMenuLabel.topAnchor.constraint(equalTo: notesLabel.topAnchor),
            priceMenuLabel.leadingAnchor.constraint(greaterThanOrEqualTo: notesLabel.trailingAnchor, constant: 16),
            priceMenuLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            editMenuButton.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 16),
            editMenuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            editMenuButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            menuQtyStepper.topAnchor.constraint(equalTo: editMenuButton.topAnchor),
            menuQtyStepper.leadingAnchor.constraint(greaterThanOrEqualTo: editMenuButton.trailingAnchor, constant: 16),
            menuQtyStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            menuQtyStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            heightAnchor.constraint(equalToConstant: 100),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    func updatePrice() {
        guard let menuOrder else {return}
        priceMenuLabel.text = "Rp. \(menuOrder.menu.price * Float(menuOrder.qty))"
    }
    
    @objc
    func editButtonDidTapped() {
        delegate?.onEditButtonDidTapped(index: tag)
    }
}

extension MenuOrderView: MenuQtyStepperViewDelegate {
    func onIncrementMenuQtyBtnDidTapped() {
        delegate?.onIncrementMenuQtyBtnDidTapped(index: tag, qty: menuQtyStepper.currentQty)
        updatePrice()
    }
    
    func onDecrementMenuQtyBtnDidTapped() {
        delegate?.onDecrementMenuQtyBtnDidTapped(index: tag, qty: menuQtyStepper.currentQty)
        updatePrice()
    }
}
