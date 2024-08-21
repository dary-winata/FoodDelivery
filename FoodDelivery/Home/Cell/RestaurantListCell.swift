//
//  RestaurantListCell.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 27/06/24.
//

import UIKit

class RestaurantListCell: UICollectionViewCell {
    private lazy var restaurantImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var restaurantNameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        return label
    }()
    
    private lazy var cuisineLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        
        return label
    }()
    
    static func getHeight() -> CGFloat {
        return 290.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(cellModel: RestaurantListCellModel) {
        // function load data dari url menjadi UIImage
        // set uiimage hasil load ke restaurantImageView
        if let imageUrlString: String = cellModel.restaurantImageURL,
            let imageUrl: URL = URL(string: imageUrlString) {
            restaurantImageView.load(url: imageUrl)
        }
        restaurantNameLabel.text = cellModel.restaurantName
        cuisineLabel.text = cellModel.cuisineName
    }
}

private extension RestaurantListCell {
    func setupView() {
        contentView.addSubview(restaurantImageView)
        contentView.addSubview(restaurantNameLabel)
        contentView.addSubview(cuisineLabel)
        
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            restaurantImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 200),
            
            restaurantNameLabel.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: 16),
            restaurantNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            restaurantNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            cuisineLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 16),
            cuisineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cuisineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cuisineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
    }
}
