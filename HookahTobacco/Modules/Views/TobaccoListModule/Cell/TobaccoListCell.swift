//
//  TobaccoListCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//

import UIKit
import SnapKit
import TableKit

struct TobaccoListTableCellItem {
    let name: String
    let tasty: String
    let manufacturerName: String
    let image: Data?
}

final class TobaccoListCell: UITableViewCell, ConfigurableCell {
    // MARK: - UI properties
    private let tobaccoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let tastyLabel = UILabel()
    private let manufacturerLabel = UILabel()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupCell()
        setupTobaccoImageView()
        setupNameLabel()
        setupTastyLabel()
        setupManufacturerLabel()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = Colors.Cell.background
    }
    private func setupTobaccoImageView() {
        tobaccoImageView.contentMode = .scaleToFill

        contentView.addSubview(tobaccoImageView)
        tobaccoImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(LayoutValues.TobaccoImageView.padding)
            make.width.equalToSuperview().multipliedBy(LayoutValues.TobaccoImageView.ratioWidth)
            make.height.equalTo(tobaccoImageView.snp.width)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = Fonts.name
        nameLabel.numberOfLines = 2

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(tobaccoImageView.snp.trailing).offset(LayoutValues.NameLabel.left)
            make.top.trailing.equalToSuperview().inset(LayoutValues.NameLabel.padding)
            make.height.equalTo(Fonts.name.lineHeight * 2.5)
        }
    }
    private func setupTastyLabel() {
        tastyLabel.font = Fonts.tasty
        tastyLabel.numberOfLines = 0

        contentView.addSubview(tastyLabel)
        tastyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    private func setupManufacturerLabel() {
        manufacturerLabel.font = Fonts.manufacturerName
        manufacturerLabel.textAlignment = .right
        manufacturerLabel.adjustsFontSizeToFitWidth = true
        manufacturerLabel.minimumScaleFactor = 0.8

        contentView.addSubview(manufacturerLabel)
        manufacturerLabel.snp.makeConstraints { make in
            make.top.equalTo(tastyLabel.snp.bottom)
            make.leading.equalTo(tobaccoImageView.snp.trailing).offset(LayoutValues.ManufacturerLabel.left)
            make.trailing.bottom.equalToSuperview().inset(LayoutValues.ManufacturerLabel.padding)
        }
    }

    // MARK: - Override methods
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        tastyLabel.text = ""
        manufacturerLabel.text = ""
        tobaccoImageView.image = nil
    }

    // MARK: - ConfigurableCell
    func configure(with item: TobaccoListTableCellItem) {
        nameLabel.text = item.name
        tastyLabel.text = item.tasty
        manufacturerLabel.text = item.manufacturerName
        if let image = item.image {
            tobaccoImageView.image = UIImage(data: image)
        } else {
            tobaccoImageView.image = nil
        }
    }

    static var estimatedHeight: CGFloat? {
        LayoutValues.Cell.estimatedHeight
    }
}

private struct LayoutValues {
    struct Cell {
        static let estimatedHeight: CGFloat = 125.0
    }
    struct TobaccoImageView {
        static let padding: CGFloat = 8.0
        static let ratioWidth: CGFloat = 0.3
    }
    struct NameLabel {
        static let left: CGFloat = 16.0
        static let padding: CGFloat = 8.0
    }
    struct ManufacturerLabel {
        static let left: CGFloat = 16.0
        static let padding: CGFloat = 8.0
    }
}
private struct Colors {
    struct Cell {
        static let background: UIColor = .clear
    }
}
private struct Fonts {
    static let name = UIFont.appFont(size: 20, weight: .bold)
    static let tasty = UIFont.appFont(size: 16, weight: .bold)
    static let manufacturerName = UIFont.appFont(size: 20, weight: .bold)
}
