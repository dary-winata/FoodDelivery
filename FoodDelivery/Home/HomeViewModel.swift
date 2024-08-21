//
//  HomeViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/06/24.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: HomeViewModelDelegate? {get set}
    func getRestaurantList() -> [RestaurantListCellModel]
    func getCuisineList() -> [CuisineListCellModel]
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel)
    func onSetLocationButtonDidTapped()
    func onLocationPageDidPop()
}

protocol HomeViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func navigateToRestaurantPage(restaurantData: RestaurandData)
    func navigateToLocationPage()
    func updateSetLocationButton(title: String)
}

class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewModelDelegate?
    
    private var restaurantListCellModel : [RestaurantListCellModel] = []
    private var cuisineListCellModel: [CuisineListCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
        fetchRestaurantList()
        setupLocationButtonTitle()
    }
    
    func getRestaurantList() -> [RestaurantListCellModel] {
        return restaurantListCellModel
    }
    
    func getCuisineList() -> [CuisineListCellModel] {
        return cuisineListCellModel
    }
    
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel) {
        if let restaurantData = RestaurantListFetcher.shared.restaurantData?.filter({$0.name == restaurantCellModel.restaurantName}).first {
            delegate?.navigateToRestaurantPage(restaurantData: restaurantData)            
        }
    }
    
    func onSetLocationButtonDidTapped() {
        delegate?.navigateToLocationPage()
    }
    
    func onLocationPageDidPop() {
        setupLocationButtonTitle()
    }
}

private extension HomeViewModel {
    func fetchRestaurantList() {
        RestaurantListFetcher.shared.requestRestaurantList { [weak self] restaurantData, err in
            guard let self else { return }
            if err != nil {
                return
            }
            if let err {
                // handle error
            }
            guard let restaurantData, !restaurantData.isEmpty else { return }
            self.restaurantListCellModel = RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell()
            self.cuisineListCellModel = RestaurantListFetcher.shared.convertCuisinelistToRestaurantListCell()
            self.delegate?.reloadData()
        }
    }
    
    func setupLocationButtonTitle() {
        guard let savedLocation = SavedLocationService.shared.getSavedLocation() else {
            return
        }
        delegate?.updateSetLocationButton(title: savedLocation.locationName)
    }
}
