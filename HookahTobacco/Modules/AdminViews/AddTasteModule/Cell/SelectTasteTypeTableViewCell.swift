//
//
//  SelectTasteTypeTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.08.2023.
//
//

import UIKit
import TableKit
import SnapKit

final class SelectTasteTypeTableViewCellItem {
    let item: TasteType
    var isSelected: Bool

    init(item: TasteType, isSelected: Bool = false) {
        self.item = item
        self.isSelected = isSelected
    }
}

final class SelectTasteTypeTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - UI properties
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let checkmarkImageView = IconButton()

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
        setupIdLabel()
        setupNameLabel()
        setupCheckmarkImageView()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupIdLabel() {
        idLabel.font = UIFont.appFont(size: 16, weight: .regular)
        idLabel.numberOfLines = 1
        idLabel.textAlignment = .center
        idLabel.textColor = R.color.primaryTitle()

        contentView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = UIFont.appFont(size: 20, weight: .medium)
        nameLabel.numberOfLines = 1
        nameLabel.textColor = R.color.primaryTitle()
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.equalTo(idLabel.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    private func setupCheckmarkImageView() {
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    // MARK: - ConfigurableCell
    func configure(with item: SelectTasteTypeTableViewCellItem) {
        idLabel.text = item.item.id
        nameLabel.text = item.item.name
        let checkmarkImage = R.image.checkmark()
        checkmarkImageView.image = item.isSelected ? checkmarkImage : nil
        checkmarkImageView.isHidden = !item.isSelected
    }

    static var estimatedHeight: CGFloat? {
        60.0
    }
}
