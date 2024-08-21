//
//  HomeTabBarController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/06/24.
//

import UIKit

class HomeTabBarController: UITabBarController {

    let viewModel: HomeTabBarViewModelProtocol
    
    init(homeTabBarViewModelProtocol: HomeTabBarViewModelProtocol) {
        self.viewModel = homeTabBarViewModelProtocol
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
}

extension HomeTabBarController: HomeTabBarViewModelDelegate {
    func setupView() {
        //set view controller
        let homeTabBar = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let searchTabBar = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let cartTabBar = UITabBarItem(title: "Cart", image: UIImage(systemName:"cart.fill"), tag: 2)
        
        let homeVM: HomeViewModel = HomeViewModel()
        let homeVC: HomeViewController = HomeViewController(homeViewModel: homeVM)
        homeVC.tabBarItem = homeTabBar
        
        let searchVM: SearchViewModel = SearchViewModel()
        let searchVC : SearchViewController = SearchViewController(viewModel: searchVM)
        searchVC.tabBarItem = searchTabBar
        
        let cartVM: CartViewModel = CartViewModel()
        let cartVC: CartViewController = CartViewController(viewModel: cartVM)
        cartVC.tabBarItem = cartTabBar
        
        viewControllers = [homeVC, searchVC, cartVC]
        tabBar.tintColor = UIColor.systemOrange
        tabBar.backgroundColor = .white
        navigationItem.title = homeVC.tabBarItem.title
        delegate = self
    }
}

extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve])
            navigationItem.title = viewController.tabBarItem.title
        }

        return true
    }
}
