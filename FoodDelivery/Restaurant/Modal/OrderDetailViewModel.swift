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
    func onEditButtonDidTapped(index: Int)
    func onDidQtyIncressedBtnDidTapped(index: Int, qty: Int)
    func onDidQtyDecresedBtnDidTapped(index: Int, qty: Int)
    func onAddToCartBtnDidTapped()
}

protocol OrderDetailViewModelDelegate: AnyObject {
    func setupView(with menuDataList: [MenuOrder])
    func dismissModal(completion: @escaping () -> Void)
}

protocol OrderListDetailViewModelAction: AnyObject {
    func navigateToMenuDetail(menuOrder: MenuOrder, isEditing: Bool)
}

class OrderDetailViewModel: OrderDetailViewModelProtocol {
    
    weak var delegate: OrderDetailViewModelDelegate?
    weak var action: OrderListDetailViewModelAction?
    
    var menuData: [MenuOrder]
    
    init(menuData: [MenuOrder]) {
        self.menuData = menuData
    }
    
    func viewDidLoad() {
        delegate?.setupView(with: menuData)
    }
    
    func onEditButtonDidTapped(index: Int) {
        //dismiss lalu navigasi kembali ke menu detail
        let menuOrder: MenuOrder = menuData[index]
        delegate?.dismissModal {
            self.action?.navigateToMenuDetail(menuOrder: menuOrder, isEditing: true)
        }
    }
    
    func onDidQtyIncressedBtnDidTapped(index: Int, qty: Int) {
        menuData[index].qty = qty
        MenuCartService.shared.updateOrder(for: menuData[index])
    }
    
    func onDidQtyDecresedBtnDidTapped(index: Int, qty: Int) {
        menuData[index].qty = qty
        MenuCartService.shared.updateOrder(for: menuData[index])
    }
    
    func onAddToCartBtnDidTapped() {
        if let firstMenu = menuData.first?.menu {
            let menuOrder: MenuOrder = MenuOrder(menu: firstMenu, qty: 0)
            delegate?.dismissModal {
                self.action?.navigateToMenuDetail(menuOrder: menuOrder, isEditing: false)
            }
        }
        
    }
}
