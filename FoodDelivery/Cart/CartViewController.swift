//
//  CartViewController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/06/24.
//

import UIKit

class CartViewController: UIViewController {

    let viewModel: CartViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartCell.self, forCellReuseIdentifier: "cart_cell")
        
        return tableView
    }()
    
    init(viewModel: CartViewModelProtocol) {
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

extension CartViewController: CartViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func navigateToRestaurantPage(cartData: CartData) {
        let viewModel: RestaurantViewModel = RestaurantViewModel(restaurantData: cartData.restaurantData, cartData: cartData)
        let viewController: RestaurantViewController = RestaurantViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCartCellList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "cart_cell") as? CartCell else {
            return UITableViewCell()
        }
        cell.setupCellModel(cartCellModel: viewModel.getCartCellList()[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onDidSelectCart(index: indexPath.row)
    }
}
