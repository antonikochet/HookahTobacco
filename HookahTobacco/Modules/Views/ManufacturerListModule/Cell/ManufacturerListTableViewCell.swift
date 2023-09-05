//
//  ManufacturerListTableViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//

import UIKit
import SnapKit
import TableKit

struct ManufacturerListTableViewCellItem {
    let name: String
    let country: String
    let image: Data?
}

final class ManufacturerListTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - UI properties
    private let containerView = UIView()
    private let imageManufacturerView = UIImageView()
    private let nameLabel = UILabel()
    private let countryLabel = UILabel()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupCell()
        setupContainerView()
        setupImageManufacturerView()
        setupNameLabel()
        setupCountryLabel()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupContainerView() {
        containerView.backgroundColor = R.color.secondaryBackground()
        containerView.layer.cornerRadius = 16.0
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4.0)
            make.leading.trailing.equalToSuperview().inset(8.0)
        }
    }
    private func setupImageManufacturerView() {
        imageManufacturerView.backgroundColor = R.color.primaryWhite()
        imageManufacturerView.contentMode = .scaleAspectFit
        imageManufacturerView.layer.cornerRadius = 16.0
        imageManufacturerView.clipsToBounds = true

        containerView.addSubview(imageManufacturerView)
        imageManufacturerView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8.0)
            make.size.equalTo(90.0).priority(999)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = UIFont.appFont(size: 24, weight: .semibold)
        nameLabel.textAlignment = .left
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.6
        nameLabel.numberOfLines = 1

        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageManufacturerView.snp.trailing).offset(16.0)
            make.top.trailing.equalToSuperview().offset(8.0)
        }
    }
    private func setupCountryLabel() {
        countryLabel.font = UIFont.appFont(size: 18, weight: .medium)
        countryLabel.textAlignment = .left
        countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.minimumScaleFactor = 0.6
        countryLabel.numberOfLines = 1

        containerView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(nameLabel.snp.bottom).offset(8.0)
        }
    }

    // MARK: - Override methods
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        countryLabel.text = ""
        imageManufacturerView.image = nil
    }

    // MARK: - ConfigurableCell
    func configure(with item: ManufacturerListTableViewCellItem) {
        nameLabel.text = item.name
        countryLabel.text = item.country
        if let image = item.image {
            imageManufacturerView.image = UIImage(data: image)
        }
    }

    static var estimatedHeight: CGFloat? {
        80.0
    }
}
