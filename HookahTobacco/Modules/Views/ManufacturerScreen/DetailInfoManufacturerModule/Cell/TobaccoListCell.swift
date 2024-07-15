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
    private let containerView = UIView()
    private let containerImageView = UIView()
    private let tobaccoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let tastyLabel = UILabel()
    private let manufacturerLabel = UILabel()
    private let favoriteButton = IconButton()
    private let wantButButton = IconButton()

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
        setupContainerView()
        setupTobaccoImageView()
        setupFavoriteButton()
        setupWantBuyButton()
        setupNameLabel()
        setupTastyLabel()
        setupManufacturerLabel()
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
    private func setupTobaccoImageView() {
        containerImageView.layer.cornerRadius = 16.0
        containerImageView.clipsToBounds = true
        containerImageView.backgroundColor = R.color.primaryWhite()
        containerView.addSubview(containerImageView)
        containerImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(8.0)
        }

        tobaccoImageView.contentMode = .scaleToFill
        containerImageView.addSubview(tobaccoImageView)
        tobaccoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10.0)
            make.size.equalTo(90).priority(999)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = UIFont.appFont(size: 20, weight: .semibold)
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping

        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(containerImageView.snp.trailing).offset(16.0)
            make.top.equalToSuperview().offset(8.0)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8.0)
        }
    }
    private func setupTastyLabel() {
        tastyLabel.font = UIFont.appFont(size: 14, weight: .regular)
        tastyLabel.numberOfLines = 3

        containerView.addSubview(tastyLabel)
        tastyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
        }
    }
    private func setupManufacturerLabel() {
        manufacturerLabel.font = UIFont.appFont(size: 20, weight: .semibold)
        manufacturerLabel.textAlignment = .right
        manufacturerLabel.adjustsFontSizeToFitWidth = true
        manufacturerLabel.minimumScaleFactor = 0.8

        containerView.addSubview(manufacturerLabel)
        manufacturerLabel.snp.makeConstraints { make in
            make.leading.equalTo(tobaccoImageView.snp.trailing).offset(16.0)
            make.trailing.bottom.equalToSuperview().inset(8.0)
        }
    }
    private func setupFavoriteButton() {
        favoriteButton.action = { [weak self] in
            guard let self, let item = self.item else { return }
            item.favoriteAction?(item)
        }
        favoriteButton.image = Images.notFavorite

        containerView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8.0)
        }
    }
    private func setupWantBuyButton() {
        wantButButton.action = { [weak self] in
            guard let self, let item = self.item else { return }
            item.wantBuyAction?(item)
        }
        wantButButton.image = Images.notWantBuy

        containerView.addSubview(wantButButton)
        wantButButton.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom).offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
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
        favoriteButton.image = isFavorite ? Images.favorite : Images.notFavorite
    }
    private func configureWantBuyButton(with item: TobaccoListTableCellItem) {
        wantButButton.isHidden = !item.isShowWantBuyButton
        wantButButton.image = item.isWantBuy ? Images.wantBuy : Images.notWantBuy
    }

    static var estimatedHeight: CGFloat? {
        125.0
    }

    // MARK: - Selectors
}

private struct Images {
    static let favorite = R.image.heartFill()!
    static let notFavorite = R.image.heart()!
    static let notWantBuy = R.image.basket()!
    static let wantBuy = R.image.basketFill()!
}
