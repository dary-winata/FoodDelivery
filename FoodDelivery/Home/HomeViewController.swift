//
//  ViewController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/06/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModelProtocol
    
    private lazy var setLocationBtn: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.tintColor = UIColor.systemOrange
        var configButton = UIButton.Configuration.borderedTinted()
        configButton.title = "Set Location"
        configButton.image = UIImage(systemName: "mappin.and.ellipse")
        configButton.buttonSize = .medium
        configButton.cornerStyle = .capsule
        btn.configuration = configButton
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(setLocationButtonDidTapped), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField: UISearchTextField = UISearchTextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionFlowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionHeadersPinToVisibleBounds = true
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantListCell.self, forCellWithReuseIdentifier: "restaurant_list")
        collectionView.register(CuisineCorouselListCell.self, forCellWithReuseIdentifier: "cuisine_corousel")
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        return collectionView
    }()
    
    private var listCellModel: [CuisineListCellModel] = []
    
    init(homeViewModel: HomeViewModel) {
        self.viewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.onViewDidLoad()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func setupView() {
        view.backgroundColor = .systemBackground
        title = "Home"
        
        view.addSubview(setLocationBtn)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            setLocationBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            setLocationBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            setLocationBtn.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            searchTextField.topAnchor.constraint(equalTo: setLocationBtn.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func navigateToRestaurantPage(restaurantData: RestaurandData) {
        let viewModel = RestaurantViewModel(restaurantData: restaurantData)
        let viewController = RestaurantViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToLocationPage() {
        let viewModel = LocationViewModel()
        viewModel.action = self
        let viewController = LocationViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateSetLocationButton(title: String) {
        if var config = setLocationBtn.configuration {
            config.title = title
            setLocationBtn.configuration = config
            setLocationBtn.updateConfiguration()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewModel.getCuisineList().isEmpty {
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            //cuisine
            let numberOfSection  = !viewModel.getCuisineList().isEmpty ?  1 :  0
            return numberOfSection
        } else {
            //restaurant
            return viewModel.getRestaurantList().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisine_corousel", for: indexPath) as? CuisineCorouselListCell else {
                return UICollectionViewCell()
            }
            cell.setupDataModel(dataModel: viewModel.getCuisineList())
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurant_list", for: indexPath) as? RestaurantListCell else {
                return UICollectionViewCell()
            }
            
            cell.setupData(cellModel: viewModel.getRestaurantList()[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: CuisineCorouselListCell.getHeight())
        } else {
            return CGSize(width: UIScreen.main.bounds.width-32, height: RestaurantListCell.getHeight())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? HomeHeaderView else {
            return UICollectionReusableView()
        }
        
        if indexPath.section == 0 {
            if viewModel.getCuisineList().isEmpty && !viewModel.getRestaurantList().isEmpty {
                view.setupTitle(title: "Restaurant")
            } else {
                view.setupTitle(title: "Cuisine")
            }
        } else {
            view.setupTitle(title: "Restaurant")
        }
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: HomeHeaderView.getHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if viewModel.getCuisineList().isEmpty && !viewModel.getRestaurantList().isEmpty {
                viewModel.onRestaurantListCellDidTapped(restaurantCellModel: viewModel.getRestaurantList()[indexPath.row])
            } else {
                //cuisine
            }
        } else {
            viewModel.onRestaurantListCellDidTapped(restaurantCellModel: viewModel.getRestaurantList()[indexPath.row])
        }
    }
}

extension HomeViewController: LocationViewModelAction {
    func onLocationPageDidPop() {
        viewModel.onLocationPageDidPop()
    }
}

private extension HomeViewController {
    @objc
    func setLocationButtonDidTapped() {
        viewModel.onSetLocationButtonDidTapped()
    }
}

