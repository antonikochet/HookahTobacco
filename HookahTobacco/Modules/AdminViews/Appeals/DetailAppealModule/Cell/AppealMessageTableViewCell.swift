//
//
//  AppealMessageTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 21.09.2023.
//
//

import UIKit
import TableKit

struct AppealMessageTableViewCellItem {
    let title: String
    let message: String
}

final class AppealMessageTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - Private properties

    // MARK: - UI properties
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupCell()
        setupTitleLabel()
        setupMessageLabel()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupTitleLabel() {
        titleLabel.setForTitleName()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    private func setupMessageLabel() {
        messageLabel.font = UIFont.appFont(size: 14.0, weight: .regular)
        messageLabel.textColor = R.color.primaryTitle()
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }
    // MARK: - Private methods

    // MARK: - ConfigurableCell
    func configure(with item: AppealMessageTableViewCellItem) {
        titleLabel.text = item.title
        messageLabel.text = item.message
    }

    // MARK: - Selectors
}
