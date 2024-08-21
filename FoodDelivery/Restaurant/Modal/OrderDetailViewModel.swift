//
//  OrderDetailViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 06/08/24.
//

import Foundation

protocol OrderDetailViewModelProtocol: AnyObject {
    var delegate: OrderDetailViewModelDelegate? {get set}
    func viewDidLoad()
}

protocol OrderDetailViewModelDelegate: AnyObject {
    func setupView(with menuDataList: [MenuOrder])
}

class OrderDetailViewModel: OrderDetailViewModelProtocol {
    weak var delegate: OrderDetailViewModelDelegate?
    
    var menuData: [MenuOrder]
    
    init(menuData: [MenuOrder]) {
        self.menuData = menuData
    }
    
    func viewDidLoad() {
        delegate?.setupView(with: menuData)
    }
}
