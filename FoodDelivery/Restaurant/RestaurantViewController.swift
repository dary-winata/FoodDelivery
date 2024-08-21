//
//  RestaurantViewController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/07/24.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    private lazy var cuisineLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        return imageView
    }()
    
    private lazy var locationPinLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var menuListLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Menu List"
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MenuListCell.self, forCellWithReuseIdentifier: "menu_list_cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private lazy var checkoutBtn: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 6
        btn.layer.masksToBounds = true
        btn.setTitle("Check Out", for: .normal)
        btn.backgroundColor = .gray
        btn.tintColor = .systemOrange
        btn.addTarget(self, action: #selector(checkoutButtonDidTapped), for: .touchUpInside)
        
        return btn
    }()
    
    let viewModel: RestaurantViewModelProtocol
    
    init(viewModel: RestaurantViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
}

extension RestaurantViewController: RestaurantViewModelDelegate {
    func setupView(restaurantName: String, cuisineName: String, location: String) {
        view.backgroundColor = .white
        title = restaurantName
        cuisineLabel.text = cuisineName
        locationPinLabel.text = location
        
        let separator: UIView = UIView(frame: .zero)
        separator.backgroundColor = .gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorButton: UIView = UIView(frame: .zero)
        separatorButton.backgroundColor = .gray
        separatorButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cuisineLabel)
        view.addSubview(locationPinLabel)
        view.addSubview(locationImageView)
        view.addSubview(menuListLabel)
        view.addSubview(separator)
        view.addSubview(collectionView)
        view.addSubview(separatorButton)
        view.addSubview(checkoutBtn)
        
        NSLayoutConstraint.activate([
            cuisineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuisineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cuisineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            locationImageView.topAnchor.constraint(equalTo: cuisineLabel.bottomAnchor, constant: 16),
            locationImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            locationPinLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 8),
            locationPinLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationPinLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            separator.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 16),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            menuListLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16),
            menuListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: menuListLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            separatorButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            separatorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorButton.heightAnchor.constraint(equalToConstant: 1),
            
            checkoutBtn.topAnchor.constraint(equalTo: separatorButton.bottomAnchor, constant: 16),
            checkoutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkoutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkoutBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func presentDetailMenuModally(with menuOrder: MenuOrder) {
        presentMenuDetailModally(with: menuOrder, isEditing: false)
    }
    
    func presentOrderListDetailModally(with menuListOrder: [MenuOrder]) {
        let viewModel: OrderDetailViewModel = OrderDetailViewModel(menuData: menuListOrder)
        let viewController: OrderListViewController = OrderListViewController(viewModel: viewModel)
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
    
    
    func updateCheckoutButtonTitle(with text: String) {
        checkoutBtn.setTitle(text, for: .normal)
    }
    
    func navigateToCheckoutPage() {
        let checkoutViewModel: CheckoutViewModel = CheckoutViewModel(restaurantData: viewModel.getRestaurantData())
        let checkoutViewController: CheckoutViewController = CheckoutViewController(viewModel: checkoutViewModel)
        
        navigationController?.pushViewController(checkoutViewController, animated: true)
    }
}

private extension RestaurantViewController {
    func presentMenuDetailModally(with menuOrder: MenuOrder, isEditing: Bool) {
        let viewModel: MenuDetailViewModel = MenuDetailViewModel(menuOrder: menuOrder, isEditing: isEditing)
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
    
    @objc
    func checkoutButtonDidTapped() {
        viewModel.onCheckoutButtonDidTapped()
    }
}

extension RestaurantViewController: MenuDetailViewModelAction {
    func onDismissModal() {
        viewModel.onDismissModal()
    }
}


extension RestaurantViewController: OrderListDetailViewModelAction {
    func navigateToMenuDetail(menuOrder: MenuOrder, isEditing: Bool) {
        presentMenuDetailModally(with: menuOrder, isEditing: isEditing)
    }
}

extension RestaurantViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMenuListModel().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menu_list_cell", for: indexPath) as? MenuListCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.setupCellModel(cellModel: viewModel.getMenuListModel()[indexPath.row])
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: MenuListCell.getHeight())
    }
}

extension RestaurantViewController: MenuListCellDelegate {
    func onAddButtonDidTapped(cellIndex: Int) {
        viewModel.onAddButtonDidTapped(cellIndex: cellIndex)
    }
    
    func onMenuImageViewDidTapped(cellIndex: Int) {
        viewModel.onAddButtonDidTapped(cellIndex: cellIndex)
    }
}
