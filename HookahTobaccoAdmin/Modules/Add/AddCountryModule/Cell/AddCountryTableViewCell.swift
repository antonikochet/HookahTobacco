//
//
//  AddCountryTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import UIKit
import TableKit
import SnapKit

struct AddCountryTableViewCellItem {
    let country: Country
}

final class AddCountryTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - UI properties
    private let idLabel = UILabel()
    private let nameLabel = UILabel()

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
            make.leading.top.bottom.equalToSuperview().inset(4)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    private func setupNameLabel() {
        nameLabel.font = UIFont.appFont(size: 20, weight: .medium)
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .right
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(idLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(4)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: AddCountryTableViewCellItem) {
        idLabel.text = String(item.country.uid)
        nameLabel.text = item.country.name
    }
}
