//
//  HomeTabBarViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/06/24.
//

import Foundation

protocol HomeTabBarViewModelProtocol: AnyObject {
    func onViewWillAppear()
    var delegate: HomeTabBarViewModelDelegate? {get set}
}

protocol HomeTabBarViewModelDelegate: AnyObject {
    func setupView()
}

class HomeTabBarViewModel: HomeTabBarViewModelProtocol {
    
    weak var delegate: HomeTabBarViewModelDelegate?
    
    func onViewWillAppear() {
        delegate?.setupView()
    }
}
