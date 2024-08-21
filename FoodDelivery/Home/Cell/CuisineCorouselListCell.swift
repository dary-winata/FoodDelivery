//
//  CuisineCorouselListCell.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 06/07/24.
//

import UIKit

class CuisineCorouselListCell: UICollectionViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32.0
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CuisineListCell.self, forCellWithReuseIdentifier: "cuisine_list")
        
        return collectionView
    }()
    
    private var listCellModel : [CuisineListCellModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getHeight() -> CGFloat {
        return 128.0
    }
    func setupDataModel(dataModel: [CuisineListCellModel]) {
        listCellModel = dataModel
        collectionView.reloadData()
    }
}

private extension CuisineCorouselListCell {
    func setupView() {
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

extension CuisineCorouselListCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisine_list", for: indexPath) as? CuisineListCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCellModel(cellData: listCellModel[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 112)
    }
}

class CuisineListCell: UICollectionViewCell {
    private lazy var cuisineImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var cuisineLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func setupCellModel(cellData: CuisineListCellModel) {
        if let cuisineURL = cellData.cuisineImageURL, 
            let imageUrl = URL(string: cuisineURL) {
            cuisineImageView.load(url: imageUrl)
        }
        cuisineLabel.text = cellData.cuisineName
    }
}

private extension CuisineListCell {
    func setupView() {
        contentView.addSubview(cuisineImageView)
        contentView.addSubview(cuisineLabel)
        
        NSLayoutConstraint.activate([
            cuisineImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cuisineImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            cuisineLabel.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 8),
            cuisineLabel.centerXAnchor.constraint(equalTo: cuisineImageView.centerXAnchor),
            cuisineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
