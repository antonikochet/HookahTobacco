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
        backgroundColor = Colors.Cell.background
    }
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .label
        iconImageView.image = Images.icon.withRenderingMode(.alwaysTemplate)

        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(LayoutValues.IconImageView.padding)
            make.height.equalTo(0)
        }
    }
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.title
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(LayoutValues.Labels.vertPadding)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Labels.horizPadding)
            make.height.equalTo(0)
        }
    }
    private func setupDescriptionLabel() {
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = Fonts.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutValues.Labels.vertPadding)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Labels.horizPadding)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(LayoutValues.Labels.vertPadding)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: EmptyTableCellItem) {
        configureTitleLabel(item)
        configureDescriptionLabel(item)
        configureIconImageView(item)
    }
    private func configureTitleLabel(_ item: EmptyTableCellItem) {
        let text = item.title
        titleLabel.text = text
        let width = contentView.frame.width - LayoutValues.Labels.horizPadding * 2.0
        let height = text.height(width: width, font: Fonts.title)
        titleLabel.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    private func configureDescriptionLabel(_ item: EmptyTableCellItem) {
        let text = item.description
        descriptionLabel.text = text
        let width = contentView.frame.width - LayoutValues.Labels.horizPadding * 2.0
        let height = text.height(width: width, font: Fonts.description)
        descriptionLabel.snp.updateConstraints { make in
            make.height.equalTo(!text.isEmpty ? height : 0)
        }
    }
    private func configureIconImageView(_ item: EmptyTableCellItem) {
        let width = contentView.frame.width - LayoutValues.Labels.horizPadding * 2.0
        let titleHeight = item.title.height(width: width, font: Fonts.title)
        let descHeihgt = item.description.height(width: width, font: Fonts.description)
        let height = (LayoutValues.Cell.estimatedHeight -
                      LayoutValues.IconImageView.padding -
                      // icon
                      LayoutValues.Labels.vertPadding -
                      titleHeight -
                      LayoutValues.Labels.vertPadding -
                      descHeihgt -
                      LayoutValues.Labels.vertPadding)
        iconImageView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

    static var estimatedHeight: CGFloat? {
        LayoutValues.Cell.estimatedHeight
    }
}

private struct LayoutValues {
    struct Cell {
        static let estimatedHeight: CGFloat = 250.0
    }
    struct IconImageView {
        static let padding: CGFloat = 8.0
    }
    struct Labels {
        static let vertPadding: CGFloat = 8.0
        static let horizPadding: CGFloat = 8.0
    }
}
private struct Images {
    static let icon = UIImage(systemName: "magnifyingglass.circle")!
}
private struct Colors {
    struct Cell {
        static let background: UIColor = .clear
    }
}
private struct Fonts {
    static let title = UIFont.appFont(size: 26, weight: .bold)
    static let description = UIFont.appFont(size: 18, weight: .regular)
}
