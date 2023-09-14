//
//
//  SelectListBottomSheetTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//
//

import UIKit
import TableKit
import SnapKit

struct SelectListBottomSheetTableViewCellItem {
    let title: String
    var isSelect: Bool
}

final class SelectListBottomSheetTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let checkmarkIcon = IconView()

    private var titleLabelTrailingConstraint: Constraint!
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
        setupCheckmarkIcon()
        setupTitleLabel()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setupCheckmarkIcon() {
        checkmarkIcon.image = R.image.checkmark()
        checkmarkIcon.isHidden = true
        contentView.addSubview(checkmarkIcon)
        checkmarkIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16.0)
        }
    }
    private func setupTitleLabel() {
        titleLabel.font = UIFont.appFont(size: 16, weight: .regular)
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.top.bottom.equalToSuperview().inset(12.0)
            make.trailing.equalToSuperview().inset(16.0).priority(.medium)
            titleLabelTrailingConstraint = make.trailing.equalTo(checkmarkIcon.snp.leading).inset(8.0).constraint
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: SelectListBottomSheetTableViewCellItem) {
        titleLabel.text = item.title
        checkmarkIcon.isHidden = !item.isSelect
        titleLabelTrailingConstraint.isActive = item.isSelect
    }
}
