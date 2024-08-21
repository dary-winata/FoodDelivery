//
//  MenuCartService.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 17/08/24.
//

import Foundation

class CartData: Codable {
    var restaurantData: RestaurandData
    var orderList: [MenuOrder]
    
    init(restaurantData: RestaurandData, orderList: [MenuOrder]) {
        self.restaurantData = restaurantData
        self.orderList = orderList
    }
}

class MenuCartService {
    static var shared: MenuCartService = MenuCartService()
    
    var cartData: CartData?
    
    func updateOrder(for menuOrder: MenuOrder) {
        guard let cartData else { return }
        if let index = cartData.orderList.firstIndex(where: { $0.menu.name == menuOrder.menu.name && $0.notes?.lowercased() == menuOrder.notes?.lowercased() }) {
            if menuOrder.qty == 0 {
                cartData.orderList.remove(at: index)
            } else {
                cartData.orderList[index] = menuOrder
            }
        } else {
            cartData.orderList.append(menuOrder)
        }
    }

    func getTotalPrice() -> Float {
        var totalPrice: Float = 0
        guard let cartData else { return 0}
        
        for cart in cartData.orderList {
            totalPrice += cart.menu.price * Float(cart.qty)
        }
        
         return totalPrice
    }
    
    func getTotalOrder(menu: MenuData) -> Int {
        var totalOrder: Int = 0
        guard let cartData else { return 0}
        
        for cart in cartData.orderList {
            if cart.menu.name == menu.name {
                totalOrder += cart.qty
            }
        }
        
         return totalOrder
    }
    
    func getTotalOrder(carts: CartData) -> Int {
        var totalOrder: Int = 0
        for order in carts.orderList {
            totalOrder += order.qty
        }
        
        return totalOrder
    }
    
    func getTotalOrder() -> Int {
        guard let cartData else {return 0}
        return getTotalOrder(carts: cartData)
    }
    
    func getOrderList(for menu: MenuData) -> [MenuOrder] {
        var menuOrder: [MenuOrder] = []
        guard let cartData else {return []}
        
        for cart in cartData.orderList {
            if cart.menu.name == menu.name {
                menuOrder.append(cart)
            }
        }
        
        return menuOrder
    }
    
    func overrideOrderlist(with menuOrder: MenuOrder, index: Int) {
        guard let cartData else {return}
        if menuOrder.qty == 0 {
            cartData.orderList.remove(at: index)
        } else {
            cartData.orderList[index] = menuOrder
        }
    }
}
