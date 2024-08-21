//
//  MenuQtyStepperView.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 06/08/24.
//

import UIKit

protocol MenuQtyStepperViewDelegate: AnyObject {
    func onIncrementMenuQtyBtnDidTapped()
    func onDecrementMenuQtyBtnDidTapped()
}

class MenuQtyStepperView: UIView {
    
    weak var delegate: MenuQtyStepperViewDelegate?
    
    private lazy var decrementMenuQtyBtn: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "minus.square"), for: .normal)
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.addTarget(self, action: #selector(decrementMenuQtyBtnDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var menuQtyLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var incrementMenuQtyBtn: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "plus.square"), for: .normal)
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.addTarget(self, action: #selector(incrementMenuQtyBtnDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    var currentQty: Int = 0 {
        didSet {
            menuQtyLabel.text = "\(currentQty)"
        }
    }
    var minimumQty: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MenuQtyStepperView {
    
    func setupView() {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [decrementMenuQtyBtn, menuQtyLabel, incrementMenuQtyBtn])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    func decrementMenuQtyBtnDidTapped() {
        if currentQty > minimumQty {
            currentQty -= 1
            delegate?.onDecrementMenuQtyBtnDidTapped()
        }
    }
    
    @objc
    func incrementMenuQtyBtnDidTapped() {
        currentQty += 1
        delegate?.onIncrementMenuQtyBtnDidTapped()
    }
}
