//
//  SavedCartService.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 21/08/24.
//

import Foundation

class SavedCartService {
    static let shared: SavedCartService = SavedCartService()
    
    func loadServiceCarts() -> [CartData] {
        if let savedCartData = UserDefaults.standard.object(forKey: "list_cart") as? Data {
            let decoder = JSONDecoder()
            if let loadedCartData = try? decoder.decode([CartData].self, from: savedCartData) {
                return loadedCartData
            }
        }
        
        return []
    }
    
    func saveCartData(_ cartData: CartData) {
        var cartDatas: [CartData] = loadServiceCarts()
        if let existenceCartIndex = cartDatas.firstIndex(where: { $0.restaurantData.name == cartData.restaurantData.name }) {
            cartDatas[existenceCartIndex] = cartData
        } else {
            cartDatas.append(cartData)
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cartDatas) {
            UserDefaults.standard.set(encoded, forKey: "list_cart")
        }
    }
}
