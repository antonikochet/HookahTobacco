//
//  DetailInfoManufacturerTableCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//

import UIKit
import SnapKit

protocol DetailInfoManufacturerCellViewModelProtocol {
    var country: String { get }
    var description: String { get }
    var iconImage: Data? { get }
}

final class DetailInfoManufacturerTableCell: UITableViewCell {
    // MARK: - Static properties
    static let identifier = NSStringFromClass(DetailInfoManufacturerTableCell.self)

    // MARK: - Public properties
    var viewModel: DetailInfoManufacturerCellViewModelProtocol? {
        didSet {
            if let viewModel = viewModel {
                updateContentCell(viewModel)
            }
        }
    }
    
    var heightCell: CGFloat {
        16 + iconImage.frame.height +
        16 + countryLabel.frame.height +
        16 + descriptionLabel.frame.height
    }
    
    //MARK: - Private properties
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .label
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 20, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(iconImage.snp.width)
        }
        
        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Private methods
    private func updateContentCell(_ viewModel: DetailInfoManufacturerCellViewModelProtocol) {
        countryLabel.text = viewModel.country
        setDescription(with: viewModel.description)
        if let icon = viewModel.iconImage {
            iconImage.image = UIImage(data: icon)
        }
    }
    
    private func setDescription(with text: String) {
        if !text.isEmpty {
            descriptionLabel.text = text
            let height = text.height(width: descriptionLabel.frame.width,
                                            font: descriptionLabel.font)
            descriptionLabel.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        } else {
            descriptionLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
    }
}
