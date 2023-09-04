//
//  DetailInfoManufacturerTableCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//

import UIKit
import SnapKit
import TableKit

struct DetailInfoManufacturerTableCellItem {
    let country: String
    let description: String
    let iconImage: Data?
}

final class DetailInfoManufacturerTableCell: UITableViewCell, ConfigurableCell {
    // MARK: - UI properties
    private let iconImage = UIImageView()
    private let countryLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        setupCell()
        setupIconImage()
        setupCountryLabel()
        setupDescriptionLabel()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupIconImage() {
        iconImage.backgroundColor = .clear
        iconImage.contentMode = .scaleAspectFit

        contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
            make.height.lessThanOrEqualTo(iconImage.snp.width)
        }
    }
    private func setupCountryLabel() {
        countryLabel.font = UIFont.appFont(size: 18, weight: .medium)
        countryLabel.numberOfLines = 1

        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.appFont(size: 16, weight: .regular)
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: DetailInfoManufacturerTableCellItem) {
        countryLabel.text = item.country
        descriptionLabel.text = item.description
        if let icon = item.iconImage {
            iconImage.image = UIImage(data: icon)
        }
    }
    static var estimatedHeight: CGFloat? {
        700.0
    }
}
