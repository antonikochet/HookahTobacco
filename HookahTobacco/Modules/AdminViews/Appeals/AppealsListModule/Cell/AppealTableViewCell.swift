//
//
//  AppealTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit
import TableKit

struct AppealTableViewCellItem {
    let info: [DescriptionStackViewItem]
}

final class AppealTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - Private properties

    // MARK: - UI properties
    private let stackView = UIStackView()

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
        setupStackView()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: 16, vertical: 8)).priority(999)
        }
    }

    // MARK: - Private methods

    // MARK: - ConfigurableCell
    func configure(with item: AppealTableViewCellItem) {
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubviewCompletely(subview)
        }
        for item in item.info {
            let descStackView = DescriptionStackView()
            descStackView.configure(with: item)
            stackView.addArrangedSubview(descStackView)
        }
    }

    // MARK: - Selectors
}
