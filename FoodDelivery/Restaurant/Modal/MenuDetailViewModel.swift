//
//  MenuDetailViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 03/08/24.
//

import Foundation

protocol MenuDetailViewModelProtocol: AnyObject {
    var delegate: MenuDetailViewModelDelegate? {get set}
    func onViewDidLoad()
    func onIncrementMenuQtyBtnDidTapped(qty: Int)
    func onDecrementMenuQtyBtnDidTapped(qty: Int)
    func onAddToCartBtnDidTapped(qty: Int, notes: String?)
}

protocol MenuDetailViewModelDelegate: AnyObject {
    func setupView()
    func configureView(with menuOrder: MenuOrder)
    func updateButtonText(text: String)
    func dismissModal(completion: @escaping () -> Void)
}

protocol MenuDetailViewModelAction: AnyObject {
    func onDismissModal()
}

class MenuDetailViewModel: MenuDetailViewModelProtocol {
    
    weak var action: MenuDetailViewModelAction?
    weak var delegate: MenuDetailViewModelDelegate?
    
    private var isEditing: Bool = false
    
    private let menuOrder: MenuOrder
    
    init(menuOrder: MenuOrder, isEditing: Bool) {
        self.menuOrder = menuOrder
        self.isEditing = isEditing
    }
    
    func onViewDidLoad() {
        delegate?.setupView()
        delegate?.configureView(with: menuOrder)
    }
    
    func onIncrementMenuQtyBtnDidTapped(qty: Int) {
        // update btn menjadi add to cart
        delegate?.updateButtonText(text: "Add To Cart - Total Rp. \(menuOrder.menu.price * Float(qty))")
    }
    
    func onDecrementMenuQtyBtnDidTapped(qty: Int) {
        if qty == 0 {
            // update btn menjadi "Remove Order"
            delegate?.updateButtonText(text: "Remove Order")
        } else {
            delegate?.updateButtonText(text: "Add To Cart - Total Rp. \(menuOrder.menu.price * Float(qty))")
        }
    }
    
    func onAddToCartBtnDidTapped(qty: Int, notes: String?) {
        let newMenuOrder: MenuOrder = MenuOrder(menu: menuOrder.menu, qty: qty, notes: notes)
        if isEditing {
            guard let cartData = MenuCartService.shared.cartData else { return }
            if let index = cartData.orderList.firstIndex(where: { $0.menu.name == menuOrder.menu.name && $0.notes?.lowercased() == menuOrder.notes?.lowercased() } ) {
                MenuCartService.shared.overrideOrderlist(with: newMenuOrder, index: index)
            }
        } else {
            let newMenuOrder: MenuOrder = MenuOrder(menu: menuOrder.menu, qty: qty, notes: notes)
            MenuCartService.shared.updateOrder(for: newMenuOrder)
        }
        delegate?.dismissModal {
            self.action?.onDismissModal()
        }
    }
}
