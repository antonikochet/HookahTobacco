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
        setupImageManufacturerView()
        setupNameLabel()
        setupCountryLabel()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = Colors.Cell.background
    }
    private func setupImageManufacturerView() {
        imageManufacturerView.tintColor = Colors.ImageManufacturerView.tint
        imageManufacturerView.contentMode = .scaleAspectFit

        contentView.addSubview(imageManufacturerView)
        imageManufacturerView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(LayoutValues.ImageManufacturerView.padding)
            make.width.equalTo(imageManufacturerView.snp.height)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = Fonts.name
        nameLabel.textAlignment = .left
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.6
        nameLabel.numberOfLines = 1

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageManufacturerView.snp.right).offset(LayoutValues.NameLabel.left)
            make.top.right.equalToSuperview().offset(LayoutValues.NameLabel.padding)
            make.height.greaterThanOrEqualTo(Fonts.name.lineHeight * nameLabel.minimumScaleFactor)
            make.height.lessThanOrEqualTo(Fonts.name.lineHeight)
        }
    }
    private func setupCountryLabel() {
        countryLabel.font = Fonts.country
        countryLabel.textAlignment = .left
        countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.minimumScaleFactor = 0.6
        countryLabel.numberOfLines = 1

        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(imageManufacturerView.snp.right).offset(LayoutValues.CountryLabel.left)
            make.right.equalToSuperview().inset(LayoutValues.CountryLabel.padding)
            make.top.equalTo(nameLabel.snp.bottom).offset(LayoutValues.CountryLabel.padding)
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
        LayoutValues.Cell.estimatedHeight
    }
}

private struct LayoutValues {
    struct Cell {
        static let estimatedHeight: CGFloat = 80.0
    }
    struct ImageManufacturerView {
        static let padding: CGFloat = 8.0
    }
    struct NameLabel {
        static let left: CGFloat = 16.0
        static let padding: CGFloat = 8.0
    }
    struct CountryLabel {
        static let left: CGFloat = 16.0
        static let padding: CGFloat = 8.0
    }
}
private struct Colors {
    struct Cell {
        static let background: UIColor = .clear
    }
    struct ImageManufacturerView {
        static let tint: UIColor = .label
    }
}
private struct Fonts {
    static let name = UIFont.appFont(size: 24, weight: .bold)
    static let country = UIFont.appFont(size: 18, weight: .medium)
}
