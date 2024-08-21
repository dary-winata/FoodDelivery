//
//  RestaurantListFetcher.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 12/07/24.
//

import Foundation

class RestaurantListFetcher {
    static let shared = RestaurantListFetcher()
    
    var restaurantData : [RestaurandData]?
    
    func requestRestaurantList(completionBlock: @escaping ([RestaurandData]?, Error?) -> Void) {
        guard let url: URL = URL(string: "https://restaurant-api-f0974-default-rtdb.firebaseio.com/restaurants.json") else {
            completionBlock(nil, NSError(domain: "Invalid URL", code: 403))
            return
        }
        let urlRequest : URLRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completionBlock(nil, error)
                return
            }
            
            guard let data = data else {
                completionBlock(nil, NSError(domain: "Data Invalid", code: 503))
                return
            }
            
            //decode json
            do {
                let decoder = JSONDecoder()
                let restaurant = try decoder.decode([RestaurandData].self, from: data)
                self.restaurantData = restaurant
                completionBlock(restaurant, nil)
            } catch {
                completionBlock(nil, error)
            }
        }
        task.resume()
     }
    
    func convertRestaurantListToRestaurantListCell() -> [RestaurantListCellModel] {
        guard let restaurantData else {return []}
        var restaurantModelList: [RestaurantListCellModel] = []
        
        for restaurant in restaurantData {
            let restaurantModel : RestaurantListCellModel = RestaurantListCellModel(restaurantImageURL: restaurant.imageURL, restaurantName: restaurant.name, cuisineName: restaurant.cuisine)
            restaurantModelList.append(restaurantModel)
        }
        
        return restaurantModelList
    }
    
    func convertCuisinelistToRestaurantListCell() -> [CuisineListCellModel] {
        guard let restaurantData else { return [] }
        var cuisineModelList: [CuisineListCellModel] = []
        
        for restaurant in restaurantData {
            if cuisineModelList.filter({ $0.cuisineName == restaurant.cuisine}).isEmpty {
                //menghindari duplicate data
                let cuisineModel = CuisineListCellModel(cuisineImageURL: restaurant.cuisineImageURL, cuisineName: restaurant.cuisine)
                cuisineModelList.append(cuisineModel)
            }
        }
        return cuisineModelList
    }
}
