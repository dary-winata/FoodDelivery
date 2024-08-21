//
//  SearchViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 20/07/24.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    var delegate: SearchViewModelDelegate? { get set }
    func onViewDidLoad()
    func getFilteredRestaurantList() -> [RestaurantListCellModel]
    func getFilteredCuisineList() -> [CuisineListCellModel]
    func onTextFieldValueDidChanged(text: String)
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel)
}

protocol SearchViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func navigateToRestaurantPage(restaurantData: RestaurandData)
}

class SearchViewModel: SearchViewModelProtocol {
    
    weak var delegate: SearchViewModelDelegate?
    
    private var restaurantList: [RestaurantListCellModel] {
        print("makan bang \(RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell())")
        return RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell()
    }
    
    private var cuisineList: [CuisineListCellModel] {
        return RestaurantListFetcher.shared.convertCuisinelistToRestaurantListCell()
    }
    
    private var filteredRestaurantList: [RestaurantListCellModel] = []
    private var filterredCuisineList: [CuisineListCellModel] = []
    
    func getFilteredRestaurantList() -> [RestaurantListCellModel] {
        return filteredRestaurantList
    }
    
    func getFilteredCuisineList() -> [CuisineListCellModel] {
        return filterredCuisineList
    }
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func onTextFieldValueDidChanged(text: String) {
        if text.isEmpty {
            resetFilterList()
        } else {
            filterCuisineList(text: text)
            filterRestaurantList(text: text)
            delegate?.reloadData()
        }
    }
    
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel) {
        if let restaurantData = RestaurantListFetcher.shared.restaurantData?.filter({$0.name == restaurantCellModel.restaurantName}).first {
            delegate?.navigateToRestaurantPage(restaurantData: restaurantData)
        }
    }
}

private extension SearchViewModel {
    func resetFilterList() {
        filterredCuisineList = []
        filteredRestaurantList = []
        delegate?.reloadData()
    }
    
    func filterRestaurantList(text: String) {
        let newFilteredRestaurantList = self.restaurantList.filter({$0.cuisineName.lowercased().contains(text.lowercased()) || $0.restaurantName.lowercased().contains(text.lowercased())})
        filteredRestaurantList = newFilteredRestaurantList
    }
    
    func filterCuisineList(text: String) {
        let newFilterCuisineList = self.cuisineList.filter({$0.cuisineName.lowercased().contains(text.lowercased())})
        filterredCuisineList = newFilterCuisineList
    }
}
