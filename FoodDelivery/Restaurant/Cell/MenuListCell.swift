//
//  MenuListCellCell.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 30/07/24.
//

import UIKit

protocol MenuListCellDelegate: AnyObject {
    func onAddButtonDidTapped(cellIndex: Int)
    func onMenuImageViewDidTapped(cellIndex: Int)
}

class MenuListCell: UICollectionViewCell {
    weak var delegate: MenuListCellDelegate?
    
    private lazy var menuImageView: UIImageView = {
        let imageView : UIImageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(menuImageViewDidTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        return imageView
    }()
    
    private lazy var menuLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var menuDescriptionLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var menuPriceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Add", for: .normal)
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemOrange
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellModel(cellModel: MenuListCellModel) {
        if let imageURL : URL = URL(string: cellModel.imageURL) {
            menuImageView.load(url: imageURL)
        }
        menuLabel.text = cellModel.name
        menuDescriptionLabel.text = cellModel.description
        menuPriceLabel.text = cellModel.price
        addBtn.setTitle(cellModel.addText, for: .normal)
    }
    
    static func getHeight() -> CGFloat {
        return 128
    }
}

private extension MenuListCell {
    func setupView() {
        let topBorder: UIView = UIView(frame: .zero)
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        topBorder.backgroundColor = .gray
        
        contentView.addSubview(topBorder)
        contentView.addSubview(menuImageView)
        contentView.addSubview(menuLabel)
        contentView.addSubview(menuPriceLabel)
        contentView.addSubview(menuDescriptionLabel)
        contentView.addSubview(addBtn)
        
        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topBorder.heightAnchor.constraint(equalToConstant: 1),
            
            menuImageView.topAnchor.constraint(equalTo: topBorder.bottomAnchor, constant: 16),
            menuImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            menuImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            menuLabel.topAnchor.constraint(equalTo: menuImageView.topAnchor),
            menuLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16),
            menuLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            menuDescriptionLabel.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 4),
            menuDescriptionLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16),
            menuDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            menuPriceLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16),
            menuPriceLabel.bottomAnchor.constraint(equalTo: menuImageView.bottomAnchor),
            
            addBtn.bottomAnchor.constraint(equalTo: menuImageView.bottomAnchor),
            addBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addBtn.leadingAnchor.constraint(equalTo: menuPriceLabel.trailingAnchor, constant: 16),
            addBtn.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc
    func addButtonDidTapped() {
        delegate?.onAddButtonDidTapped(cellIndex: tag)
    }
    
    @objc
    func menuImageViewDidTapped() {
        
    }
}
