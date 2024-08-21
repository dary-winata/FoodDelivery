//
//  CheckoutViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 19/08/24.
//

import Foundation

protocol CheckoutViewModelProtocol: AnyObject {
    var delegate: CheckoutViewModelDelegate? { get set }
    func onViewDidLoad()
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int)
    func onIncrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int)
    func onDecrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int)
    func presentDetailMenuModally(with menuOrder: MenuOrder)
    func onDetailDismissModal()
    func onPayButtonDidTapped()
}

protocol CheckoutViewModelDelegate: AnyObject {
    func setupView()
    func updateOrderList(menuOrderList: [MenuOrder], index: Int)
    func setupTotalPrice(totalPriceString: String)
    func presentDetailMenuModally(with menuOrder: MenuOrder)
    func resetStackView()
    func popToRootViewController()
}

class CheckoutViewModel: CheckoutViewModelProtocol {
    
    var delegate: CheckoutViewModelDelegate?
    
    let restaurantData: RestaurandData
    
    init(restaurantData: RestaurandData) {
        self.restaurantData = restaurantData
    }
    
    func onViewDidLoad() {
        delegate?.setupView()
        setupMenuOrderList()
        setupTotalPrice()
    }
    
    func presentDetailMenuModally(with menuOrder: MenuOrder) {
        delegate?.presentDetailMenuModally(with: menuOrder)
    }
    
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int) {
        let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: restaurantData.menus[menuIndex])
        delegate?.presentDetailMenuModally(with: orderList[orderIndex])
    }
    
    func onIncrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int) {
        let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: restaurantData.menus[menuIndex])
        let newOrder: MenuOrder = orderList[orderIndex]
        newOrder.qty = qty
        MenuCartService.shared.updateOrder(for: orderList[orderIndex])
        //update total price
        setupTotalPrice()
    }
    
    func onDecrementMenuQtyBtnDidTapped(qty: Int, orderIndex: Int, menuIndex: Int) {
        let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: restaurantData.menus[menuIndex])
        let newOrder: MenuOrder = orderList[orderIndex]
        newOrder.qty = qty
        MenuCartService.shared.updateOrder(for: orderList[orderIndex])
        setupTotalPrice()
    }
    
    func onDetailDismissModal() {
        //update total price dan order details
        setupTotalPrice()
        // cara pertama update 1 menu
        // cara 2: update semua menu order lebih baik
        setupMenuOrderList()
    }
    
    func onPayButtonDidTapped() {
        // 1. save cart data ke local storage
        guard let cartData = MenuCartService.shared.cartData else {
            return
        }
        SavedCartService.shared.saveCartData(cartData)
        
        // 2. pop viewController ke root view Controller
        delegate?.popToRootViewController()
    }
}

private extension CheckoutViewModel {
    func resetMenuOrderList() {
        delegate?.resetStackView()
    }
    
    func setupMenuOrderList() {
        resetMenuOrderList()
        for (index, menu) in restaurantData.menus.enumerated() {
            let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: menu)
            //update di vc dan append tiap view ke scrollview
            delegate?.updateOrderList(menuOrderList: orderList, index: index)
        }
    }
    
    func setupTotalPrice() {
        let totalPrice: String = "Rp. \(MenuCartService.shared.getTotalPrice())"
        delegate?.setupTotalPrice(totalPriceString: totalPrice)
    }
}
