//
//  MenuOrder.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 09/08/24.
//

import Foundation

class MenuOrder: Codable {
    var menu: MenuData
    var qty: Int
    var notes: String?
    
    init(menu: MenuData, qty: Int, notes: String? = nil) {
        self.menu = menu
        self.qty = qty
        self.notes = notes
    }
}
