//
//  AddTastesTableViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.11.2022.
//

import UIKit
import SnapKit
import TableKit

struct AddTastesTableCellViewModel {
    let taste: String
    let typeTaste: String
    let isSelect: Bool
}

class AddTastesTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Private properties
    private var checkmarkWidthConstraint: Constraint?

    // MARK: - Private UI
    private let tasteLabel = UILabel()
    private let typeTasteLabel = UILabel()
    private let checkmarkImageView = UIImageView()

    // MARK: - Init
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
        setupTasteLabel()
        setupCheckmarkImageView()
        setupTypeTasteLabel()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupTasteLabel() {
        tasteLabel.font = Fonts.taste
        tasteLabel.numberOfLines = 0
        tasteLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(40)
        }
    }
    private func setupCheckmarkImageView() {
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.tintColor = .label
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.height.equalTo(24.0)
            checkmarkWidthConstraint = make.width.equalTo(checkmarkImageView.snp.height).constraint
            make.width.equalTo(0).priority(.medium)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
        }
    }
    private func setupTypeTasteLabel() {
        typeTasteLabel.font = Fonts.type
        typeTasteLabel.numberOfLines = 1
        typeTasteLabel.textAlignment = .right
        contentView.addSubview(typeTasteLabel)
        typeTasteLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(tasteLabel.snp.trailing)
            make.trailing.equalTo(checkmarkImageView.snp.leading).inset(-4)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with viewModel: AddTastesTableCellViewModel) {
        tasteLabel.text = viewModel.taste
        typeTasteLabel.text = viewModel.typeTaste
        configureCheckmarkImageView(with: viewModel)
    }
    private func configureCheckmarkImageView(with viewModel: AddTastesTableCellViewModel) {
        let checkmarkImage = Images.checkmark
        checkmarkImageView.image = viewModel.isSelect ? checkmarkImage : nil
        checkmarkWidthConstraint?.isActive = viewModel.isSelect
    }

    static var estimatedHeight: CGFloat? {
        60
    }
}

private struct Images {
    static let checkmark = UIImage(systemName: "checkmark.circle.fill")!.withRenderingMode(.alwaysTemplate)
}
private struct Fonts {
    static let taste = UIFont.appFont(size: 22, weight: .medium)
    static let type = UIFont.appFont(size: 16, weight: .light)
}
