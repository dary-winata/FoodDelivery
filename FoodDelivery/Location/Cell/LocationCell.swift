//
//  LocationCell.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 20/08/24.
//

import UIKit

class LocationCell: UITableViewCell {
    
    private lazy var locationLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationDetailsLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellModel(cellModel: LocationCellModel) {
        locationLabel.text = cellModel.locationName
        locationDetailsLabel.text = cellModel.locationDetails
    }
}

private extension LocationCell {
    func setupView() {
        contentView.addSubview(locationLabel)
        contentView.addSubview(locationDetailsLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            locationDetailsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            locationDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            locationDetailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
