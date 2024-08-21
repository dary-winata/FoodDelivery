//
//  RestaurandData.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 12/07/24.
//

import Foundation

struct RestaurandData : Codable {
    let name: String
    let cuisine: String
    let cuisineImageURL: String
    let imageURL: String
    let location: RestaurantLocation
    let menus: [MenuData]
}

struct RestaurantLocation: Codable {
    let city: String
    let lat: Float
    let long: Float
}

struct MenuData: Codable {
    let description: String
    let imageURL: String
    let name: String
    let price: Float
}
