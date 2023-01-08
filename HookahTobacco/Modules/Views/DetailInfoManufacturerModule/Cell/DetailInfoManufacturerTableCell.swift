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
        backgroundColor = Colors.Cell.background
    }
    private func setupIconImage() {
        iconImage.backgroundColor = Colors.IconImage.background
        iconImage.contentMode = .scaleAspectFit

        contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(LayoutValues.IconImage.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.IconImage.horizPadding)
            make.height.equalTo(iconImage.snp.width)
        }
    }
    private func setupCountryLabel() {
        countryLabel.font = Fonts.country
        countryLabel.numberOfLines = 1

        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(LayoutValues.CountryLabel.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.CountryLabel.horizPadding)
            make.height.equalTo(LayoutValues.CountryLabel.height)
        }
    }
    private func setupDescriptionLabel() {
        descriptionLabel.font = Fonts.description
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(LayoutValues.DescriptionLabel.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.DescriptionLabel.horizPadding)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(LayoutValues.DescriptionLabel.bottom)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: DetailInfoManufacturerTableCellItem) {
        countryLabel.text = item.country
        configureDescriptionLabel(with: item.description)
        if let icon = item.iconImage {
            iconImage.image = UIImage(data: icon)
        }
    }
    private func configureDescriptionLabel(with text: String) {
        if !text.isEmpty {
            descriptionLabel.text = text
            let height = text.height(width: descriptionLabel.frame.width,
                                     font: Fonts.description)
            descriptionLabel.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        } else {
            descriptionLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
    }

    static var estimatedHeight: CGFloat? {
        LayoutValues.Cell.estimatedHeight
    }
}

private struct LayoutValues {
    struct Cell {
        static let estimatedHeight: CGFloat = 700.0
    }
    struct IconImage {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 32.0
    }
    struct CountryLabel {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 16.0
        static let height: CGFloat = 20.0
    }
    struct DescriptionLabel {
        static let top: CGFloat = 16.0
        static let horizPadding: CGFloat = 16.0
        static let bottom: CGFloat = 16.0
    }
}
private struct Colors {
    struct Cell {
        static let background: UIColor = .clear
    }
    struct IconImage {
        static let background: UIColor = .clear
    }
}
private struct Fonts {
    static let country = UIFont.appFont(size: 20, weight: .medium)
    static let description = UIFont.appFont(size: 18, weight: .regular)
}
