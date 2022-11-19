//
//  ManufacturerListTableViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//

import UIKit
import SnapKit

class ManufacturerListTableViewCell: UITableViewCell {
    
    static let identifier = "ManufacturerListTableViewCell"
    
    //MARK: ui property
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 24, weight: .bold)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.numberOfLines = 1
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 18, weight: .medium)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.numberOfLines = 1
        return label
    }()
    
    private let imageManufacturerView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: init cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        setupSubviews()
    }
    
    //MARK: setup cell
    private func setupSubviews() {
        addSubview(imageManufacturerView)
        imageManufacturerView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(imageManufacturerView.snp.height)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageManufacturerView.snp.right).offset(16)
            make.top.right.equalToSuperview().offset(8)
            make.height.greaterThanOrEqualTo(nameLabel.font.lineHeight * nameLabel.minimumScaleFactor)
            make.height.lessThanOrEqualTo(nameLabel.font.lineHeight)
        }
        
        addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(imageManufacturerView.snp.right).offset(16)
            make.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }
    
    //MARK: set content cell 
    func setCell(name: String, country: String, image: Data?) {
        nameLabel.text = name
        countryLabel.text = country
        if let image = image {
            imageManufacturerView.image = UIImage(data: image)
        }
    }
}
