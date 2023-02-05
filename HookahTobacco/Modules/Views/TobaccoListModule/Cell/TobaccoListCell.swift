//
//  TobaccoListCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//

import UIKit
import SnapKit
import TableKit

final class TobaccoListTableCellItem {
    let name: String
    let tasty: String
    let manufacturerName: String
    var isFavorite: Bool
    var isWantBuy: Bool
    var isShowWantBuyButton: Bool
    let image: Data?

    var favoriteAction: ((TobaccoListTableCellItem) -> Void)?
    var wantBuyAction: ((TobaccoListTableCellItem) -> Void)?

    init(name: String,
         tasty: String,
         manufacturerName: String,
         isFavorite: Bool,
         isWantBuy: Bool,
         isShowWantBuyButton: Bool,
         image: Data? = nil,
         favoriteAction: ((TobaccoListTableCellItem) -> Void)? = nil,
         wantBuyAction: ((TobaccoListTableCellItem) -> Void)? = nil) {
        self.name = name
        self.tasty = tasty
        self.manufacturerName = manufacturerName
        self.isFavorite = isFavorite
        self.isWantBuy = isWantBuy
        self.isShowWantBuyButton = isShowWantBuyButton
        self.image = image
        self.favoriteAction = favoriteAction
        self.wantBuyAction = wantBuyAction
    }
}

final class TobaccoListCell: UITableViewCell, ConfigurableCell {
    // MARK: - Private properties
    private var item: TobaccoListTableCellItem?

    // MARK: - UI properties
    private let tobaccoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let tastyLabel = UILabel()
    private let manufacturerLabel = UILabel()
    private let favoriteView = UIView()
    private let favoriteButton = UIButton()
    private let wantButButton = UIButton()

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
        setupFavoriteButton()
        setupWantBuyButton()
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
        nameLabel.lineBreakMode = .byWordWrapping

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(tobaccoImageView.snp.trailing).offset(LayoutValues.NameLabel.left)
            make.top.equalToSuperview().offset(LayoutValues.NameLabel.padding)
            make.trailing.equalTo(favoriteView.snp.leading).inset(LayoutValues.NameLabel.padding)
            make.height.equalTo(LayoutValues.NameLabel.height)
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
    private func setupFavoriteButton() {
        contentView.addSubview(favoriteView)
        favoriteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutValues.FavoriteView.top)
            make.trailing.equalToSuperview().inset(LayoutValues.FavoriteView.trailing)
            make.size.equalTo(LayoutValues.FavoriteView.size)
        }

        favoriteButton.setImage(Images.notFavorite, for: .normal)
        favoriteButton.tintColor = Colors.FavoriteButton.notPress
        favoriteButton.addTarget(self, action: #selector(pressedFavoriteButton), for: .touchUpInside)

        favoriteView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(LayoutValues.FavoriteButton.size)
        }
    }
    private func setupWantBuyButton() {
        wantButButton.setImage(Images.notWantBuy, for: .normal)
        wantButButton.tintColor = Colors.WantBuyButton.notPress
        wantButButton.addTarget(self, action: #selector(pressedWantBuyButton), for: .touchUpInside)

        contentView.addSubview(wantButButton)
        wantButButton.snp.makeConstraints { make in
            make.top.equalTo(favoriteView.snp.bottom).offset(LayoutValues.WantBuyButton.top)
            make.trailing.equalToSuperview().inset(LayoutValues.WantBuyButton.trailing)
            make.size.equalTo(LayoutValues.WantBuyButton.size)
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
        self.item = item
        nameLabel.text = item.name
        tastyLabel.text = item.tasty
        manufacturerLabel.text = item.manufacturerName
        configureFavoriteButton(isFavorite: item.isFavorite)
        configureWantBuyButton(with: item)
        if let image = item.image {
            tobaccoImageView.image = UIImage(data: image)
        } else {
            tobaccoImageView.image = nil
        }
    }
    private func configureFavoriteButton(isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? Images.favorite : Images.notFavorite, for: .normal)
        favoriteButton.tintColor = isFavorite ? Colors.FavoriteButton.press : Colors.FavoriteButton.notPress
    }
    private func configureWantBuyButton(with item: TobaccoListTableCellItem) {
        wantButButton.isHidden = !item.isShowWantBuyButton
        wantButButton.setImage(item.isWantBuy ? Images.wantBuy : Images.notWantBuy, for: .normal)
        wantButButton.tintColor = item.isWantBuy ? Colors.WantBuyButton.press : Colors.WantBuyButton.notPress
    }

    static var estimatedHeight: CGFloat? {
        LayoutValues.Cell.estimatedHeight
    }

    // MARK: - Selectors
    @objc private func pressedFavoriteButton() {
        guard let item else { return }
        item.favoriteAction?(item)
    }

    @objc private func pressedWantBuyButton() {
        guard let item else { return }
        item.wantBuyAction?(item)
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
        static let height: CGFloat = Fonts.name.lineHeight * 2.0
    }
    struct ManufacturerLabel {
        static let left: CGFloat = 16.0
        static let padding: CGFloat = 8.0
    }
    struct FavoriteView {
        static let trailing: CGFloat = 16.0
        static let top: CGFloat = 8.0
        static let size: CGFloat = 24.0
    }
    struct FavoriteButton {
        static let size: CGFloat = 24.0
    }
    struct WantBuyButton {
        static let trailing: CGFloat = 16.0
        static let top: CGFloat = 16.0
        static let size: CGFloat = 24.0
    }
}
private struct Images {
    static let favorite = UIImage(systemName: "heart.fill")!
    static let notFavorite = UIImage(systemName: "heart")!
    static let notWantBuy = UIImage(systemName: "basket")!
    static let wantBuy = UIImage(systemName: "basket.fill")!
}
private struct Colors {
    struct Cell {
        static let background: UIColor = .clear
    }
    struct FavoriteButton {
        static let press = UIColor.systemRed
        static let notPress = UIColor(white: 0.6, alpha: 1.0)
    }
    struct WantBuyButton {
        static let press = UIColor.systemOrange
        static let notPress = UIColor(white: 0.6, alpha: 1.0)
    }
}
private struct Fonts {
    static let name = UIFont.appFont(size: 20, weight: .bold)
    static let tasty = UIFont.appFont(size: 14, weight: .medium)
    static let manufacturerName = UIFont.appFont(size: 18, weight: .semibold)
}
