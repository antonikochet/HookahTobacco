//
//  EmptyTableCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.11.2022.
//

import UIKit
import SnapKit
import TableKit

struct EmptyTableCellItem {
    let title: String
    let description: String
}

class EmptyTableCell: UITableViewCell, ConfigurableCell {
    // MARK: - UI properties
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        setupCell()
        setupIconImageView()
        setupTitleLabel()
        setupDescriptionLabel()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = R.image.notFound()?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = R.color.primaryTitle()

        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(150.0)
        }
    }
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.appFont(size: 26, weight: .bold)
        titleLabel.textColor = R.color.primaryTitle()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    private func setupDescriptionLabel() {
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.appFont(size: 18, weight: .regular)
        descriptionLabel.textColor = R.color.primaryTitle()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(16.0).priority(999)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: EmptyTableCellItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }

    static var estimatedHeight: CGFloat? {
        250.0
    }
}
