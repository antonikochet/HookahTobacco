//
//  TobaccoListCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//

import UIKit
import SnapKit

struct TobaccoListCellViewModel {
    let name: String
    let tasty: String
    let manufacturerName: String
    let image: Data?
}

class TobaccoListCell: UITableViewCell {
    static let identifier = "TobaccoListCell"
    
    var viewModel: TobaccoListCellViewModel? {
        didSet {
            nameLabel.text = viewModel?.name
            tastyLabel.text = viewModel?.tasty
            manufacturerLabel.text = viewModel?.manufacturerName
            if let image = viewModel?.image {
                tobaccoImageView.image = UIImage(data: image)
            } else {
                tobaccoImageView.image = nil
            }
        }
    }
    
    private let tobaccoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let tastyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let manufacturerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 20, weight: .bold)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(tobaccoImageView)
        tobaccoImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(tobaccoImageView.snp.height)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(tobaccoImageView.snp.trailing).offset(8)
            make.top.trailing.equalToSuperview().inset(8)
            make.height.equalTo(nameLabel.font.lineHeight * 2.5)
        }
        
        contentView.addSubview(tastyLabel)
        tastyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        contentView.addSubview(manufacturerLabel)
        manufacturerLabel.snp.makeConstraints { make in
            make.top.equalTo(tastyLabel.snp.bottom)
            make.leading.equalTo(tobaccoImageView.snp.trailing).offset(8)
            make.trailing.bottom.equalToSuperview().inset(8)
        }
    }
}
