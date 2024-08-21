//
//  CheckoutLocationView.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 19/08/24.
//

import UIKit

class CheckoutLocationView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Delivery Location"
        
        return label
    }()
    
    private lazy var savedLocationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Omah"
        
        return label
    }()
    
    private lazy var locationDetailsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rumah Sapa nich"
        
        return label
    }()
    
    private lazy var setLocationBtn: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        btn.setTitle("Set Location", for: .normal)
        btn.tintColor = UIColor.systemOrange
        var configButton = UIButton.Configuration.borderedTinted()
        configButton.buttonSize = .medium
        configButton.cornerStyle = .capsule
        btn.configuration = configButton
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension CheckoutLocationView {
    func setupView() {
        addSubview(titleLabel)
        addSubview(savedLocationLabel)
        addSubview(locationDetailsLabel)
        addSubview(setLocationBtn)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            setLocationBtn.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            setLocationBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            savedLocationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            savedLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            savedLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            locationDetailsLabel.topAnchor.constraint(equalTo: savedLocationLabel.bottomAnchor, constant: 8),
            locationDetailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            locationDetailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            locationDetailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
        ])
    }
}
