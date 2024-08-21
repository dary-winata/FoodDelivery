//
//  MenuDetailViewController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 03/08/24.
//

import UIKit

class MenuDetailViewController: UIViewController {
    
    private lazy var menuImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var menuNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        return label
    }()
    
    private lazy var menuDescriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var menuPriceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Notes"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var notesTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 250)
        textField.layer.borderWidth = 1
        
        return textField
    }()
    
    private lazy var addToCartBtn: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.setTitle("Add To Cart", for: .normal)
        btn.setTitleColor(UIColor(ciColor: .black), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 250)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(addToCartBtnDidTapped), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var totalQtyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Total Quantity"
        
        return label
    }()
    
    private lazy var menuQtyStepper: MenuQtyStepperView = {
        let menuQty: MenuQtyStepperView = MenuQtyStepperView(frame: .zero)
        menuQty.translatesAutoresizingMaskIntoConstraints = false
        menuQty.delegate = self
        
        return menuQty
    }()
    
    let viewModel : MenuDetailViewModelProtocol

    init(viewModel: MenuDetailViewModel) {
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


private extension MenuDetailViewController {
    @objc
    func addToCartBtnDidTapped() {
        viewModel.onAddToCartBtnDidTapped(qty: menuQtyStepper.currentQty, notes: notesTextField.text)
    }
}

extension MenuDetailViewController: MenuDetailViewModelDelegate {

    
    func setupView() {
        view.backgroundColor = .white
        
        let separatorDescription: UIView = UIView(frame: .zero)
        separatorDescription.backgroundColor = .gray
        separatorDescription.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomSeparator: UIView = UIView(frame: .zero)
        bottomSeparator.backgroundColor = .gray
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuImage)
        view.addSubview(menuNameLabel)
        view.addSubview(menuDescriptionLabel)
        view.addSubview(menuPriceLabel)
        view.addSubview(separatorDescription)
        view.addSubview(notesLabel)
        view.addSubview(notesTextField)
        view.addSubview(bottomSeparator)
        view.addSubview(totalQtyLabel)
        view.addSubview(menuQtyStepper)
        view.addSubview(addToCartBtn)
        
        NSLayoutConstraint.activate([
            menuImage.topAnchor.constraint(equalTo: view.topAnchor),
            menuImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuImage.heightAnchor.constraint(equalTo: menuImage.widthAnchor, multiplier: 0.5),
            
            menuNameLabel.topAnchor.constraint(equalTo: menuImage.bottomAnchor, constant: 16),
            menuNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            menuDescriptionLabel.topAnchor.constraint(equalTo: menuNameLabel.bottomAnchor, constant: 8),
            menuDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            menuPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: menuDescriptionLabel.trailingAnchor, constant: 8),
            menuPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: menuNameLabel.trailingAnchor, constant: 16),
            menuPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            menuPriceLabel.centerYAnchor.constraint(equalTo: menuDescriptionLabel.topAnchor),
              
            separatorDescription.topAnchor.constraint(equalTo: menuDescriptionLabel.bottomAnchor, constant: 8),
            separatorDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorDescription.heightAnchor.constraint(equalToConstant: 1),
            
            notesLabel.topAnchor.constraint(equalTo: separatorDescription.bottomAnchor, constant: 16),
            notesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            notesTextField.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
            notesTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notesTextField.heightAnchor.constraint(equalToConstant: 60),
            
            bottomSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            totalQtyLabel.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 8),
            totalQtyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            menuQtyStepper.topAnchor.constraint(equalTo: totalQtyLabel.topAnchor),
            menuQtyStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addToCartBtn.topAnchor.constraint(equalTo: totalQtyLabel.bottomAnchor, constant: 8),
            addToCartBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addToCartBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        
    }
    
    func configureView(with menuOrder: MenuOrder) {
        if let menuURL = URL(string: menuOrder.menu.imageURL) {
            menuImage.load(url: menuURL)
        }
        menuNameLabel.text = menuOrder.menu.name
        menuPriceLabel.text = "Rp. \(menuOrder.menu.price)"
        menuDescriptionLabel.text = menuOrder.menu.description
        menuQtyStepper.currentQty = menuOrder.qty
        notesTextField.text = menuOrder.notes
    }
    
    func updateButtonText(text: String) {
        addToCartBtn.setTitle(text, for: .normal)
    }
    
    func dismissModal(completion: @escaping () -> Void) {
        dismiss(animated: true, completion: completion)
    }
}

extension MenuDetailViewController: MenuQtyStepperViewDelegate {
    func onIncrementMenuQtyBtnDidTapped() {
        viewModel.onIncrementMenuQtyBtnDidTapped(qty: menuQtyStepper.currentQty)
    }
    
    func onDecrementMenuQtyBtnDidTapped() {
        viewModel.onDecrementMenuQtyBtnDidTapped(qty: menuQtyStepper.currentQty)
    }
}
