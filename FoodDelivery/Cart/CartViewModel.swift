//
//  CartViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 21/08/24.
//

import Foundation

protocol CartViewModelProtocol: AnyObject {
    var delegate: CartViewModelDelegate? { get set }
    func onViewDidLoad()
    func getCartCellList() -> [CartCellModel]
    func onDidSelectCart(index: Int)
}

protocol CartViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func navigateToRestaurantPage(cartData: CartData)
}

class CartViewModel: CartViewModelProtocol {
    weak var delegate: CartViewModelDelegate?
    
    private var cartCellList: [CartCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
        setupCartList()
    }
    
    func getCartCellList() -> [CartCellModel] {
        return cartCellList
    }
    
    func onDidSelectCart(index: Int) {
        // navigasi ke restaurant vc
        // passing cart data
        let cartData: CartData = SavedCartService.shared.loadServiceCarts()[index]
        delegate?.navigateToRestaurantPage(cartData: cartData)
    }
}

private extension CartViewModel {
    func setupCartList() {
        var cartCellModels: [CartCellModel] = []
        let cartDataList: [CartData] = SavedCartService.shared.loadServiceCarts()
        for cart in cartDataList {
            let cartCell : CartCellModel = CartCellModel(restaurantName: cart.restaurantData.name, totalItem: "\(MenuCartService.shared.getTotalOrder(carts: cart))")
            cartCellModels.append(cartCell)
        }
        cartCellList = cartCellModels
        delegate?.reloadData()
    }
}
