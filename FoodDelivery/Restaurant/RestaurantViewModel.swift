//
//  RestaurantViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/07/24.
//

import Foundation

protocol RestaurantViewModelProtocol: AnyObject {
    var delegate: RestaurantViewModelDelegate? {get set}
    func onViewDidLoad()
    func onViewWillAppear()
    func getMenuListModel() -> [MenuListCellModel]
    func onMenuImageViewDidTapped(cellIndex: Int)
    func onAddButtonDidTapped(cellIndex: Int)
    func onDismissModal()
    func onCheckoutButtonDidTapped()
    func getRestaurantData() -> RestaurandData
}

protocol RestaurantViewModelDelegate: AnyObject {
    func setupView(restaurantName: String, cuisineName: String, location: String)
    func reloadData()
    func presentDetailMenuModally(with menuOrder: MenuOrder)
    func presentOrderListDetailModally(with menuListOrder: [MenuOrder])
    func updateCheckoutButtonTitle(with text: String)
    func navigateToCheckoutPage()
}

class RestaurantViewModel: RestaurantViewModelProtocol {

    weak var delegate: RestaurantViewModelDelegate?
    
    private let restaurantData: RestaurandData
    private let cartData: CartData?
    
    private var menuListModel: [MenuListCellModel] = []
    
    init(restaurantData: RestaurandData, cartData: CartData? = nil) {
        self.restaurantData = restaurantData
        self.cartData = cartData
    }
    
    func onViewWillAppear() {
        updateMenuListModel()
    }
    
    func onViewDidLoad() {
        delegate?.setupView(restaurantName: restaurantData.name, cuisineName: restaurantData.cuisine, location: restaurantData.location.city)
        setupMenuListModel()
        initializeMenuCart()
    }
    
    func getMenuListModel() -> [MenuListCellModel] {
        return menuListModel
    }
    
    func onAddButtonDidTapped(cellIndex: Int) {
        let menuOrderList = MenuCartService.shared.getOrderList(for: restaurantData.menus[cellIndex])
        if !menuOrderList.isEmpty {
            delegate?.presentOrderListDetailModally(with: menuOrderList)
        } else {
            delegate?.presentDetailMenuModally(with: MenuOrder(menu: restaurantData.menus[cellIndex], qty: 0))
        }
    }
    
    func onMenuImageViewDidTapped(cellIndex: Int) {
        let menuOrderList = MenuCartService.shared.getOrderList(for: restaurantData.menus[cellIndex])
        if !menuOrderList.isEmpty {
            delegate?.presentOrderListDetailModally(with: menuOrderList)
        } else {
            delegate?.presentDetailMenuModally(with: MenuOrder(menu: restaurantData.menus[cellIndex], qty: 0))
        }
    }
    
    func onDismissModal() {
        updateMenuListModel()
    }
    
    func onCheckoutButtonDidTapped() {
        if let orderList = MenuCartService.shared.cartData?.orderList, !orderList.isEmpty {
            delegate?.navigateToCheckoutPage()
        }
    }
    
    func getRestaurantData() -> RestaurandData {
        return restaurantData
    }
}

private extension RestaurantViewModel {
    
    func initializeMenuCart() {
        if let cartData {
            // pakai existing cart data
            MenuCartService.shared.cartData = cartData
        } else {
            // cart baru
            MenuCartService.shared.cartData = CartData(restaurantData: restaurantData, orderList: [])
        }
    }
    
    func setupMenuListModel() {
        var menuList: [MenuListCellModel] = []
        for menu in restaurantData.menus {
            let newMenu = MenuListCellModel(imageURL: menu.imageURL, name: menu.name, description: menu.description, price: "Rp. \(menu.price)", addText: "Add")
            menuList.append(newMenu)
        }
        
        menuListModel = menuList
        delegate?.reloadData()
    }
    
    func updateMenuListModel() {
        for (index, menuModel) in self.menuListModel.enumerated() {
            if let menu = restaurantData.menus.filter( { $0.name == menuModel.name } ).first {
                let totalMenuItem: Int = MenuCartService.shared.getTotalOrder(menu: menu)
                menuListModel[index].addText = totalMenuItem == 0 ? "Add" : "\(totalMenuItem) in cart"
            }
        }
        
        delegate?.reloadData()
        let totalPrice: Float = MenuCartService.shared.getTotalPrice()
        let totalOrder: Int = MenuCartService.shared.getTotalOrder()
        delegate?.updateCheckoutButtonTitle(with: totalOrder == 0 ? "Checkout" : "\(totalOrder) items - Total Rp. \(totalPrice * Float(totalOrder))")
    }
}
