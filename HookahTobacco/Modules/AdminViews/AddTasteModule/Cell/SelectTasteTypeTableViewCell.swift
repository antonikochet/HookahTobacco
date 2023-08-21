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

    // MARK: - Private properties
    private var checkmarkWidthConstraint: Constraint?

    // MARK: - UI properties
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let checkmarkImageView = UIImageView()

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

        contentView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = UIFont.appFont(size: 20, weight: .medium)
        nameLabel.numberOfLines = 1
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(idLabel.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    private func setupCheckmarkImageView() {
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.tintColor = .label
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().inset(4)
            checkmarkWidthConstraint = make.width.equalTo(checkmarkImageView.snp.height).constraint
            make.width.equalTo(0).priority(.medium)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    // MARK: - ConfigurableCell
    func configure(with item: SelectTasteTypeTableViewCellItem) {
        idLabel.text = item.item.id
        nameLabel.text = item.item.name
        let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")?
                                .withRenderingMode(.alwaysTemplate)
        checkmarkImageView.image = item.isSelected ? checkmarkImage : nil
        checkmarkWidthConstraint?.isActive = item.isSelected
    }

    static var estimatedHeight: CGFloat? {
        60.0
    }
}
