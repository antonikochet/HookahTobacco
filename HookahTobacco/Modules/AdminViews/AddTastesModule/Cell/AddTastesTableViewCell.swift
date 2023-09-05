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
    let id: String
    let typeTaste: String
    let isSelect: Bool
}

class AddTastesTableViewCell: UITableViewCell, ConfigurableCell {

    // MARK: - Private properties
    private var typeLabelTrainingConstraint: Constraint?

    // MARK: - Private UI
    private let idLabel = UILabel()
    private let tasteLabel = UILabel()
    private let typeTasteLabel = UILabel()
    private let checkmarkImageView = IconButton()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        setupCell()
        setupIdLabel()
        setupTasteLabel()
        setupCheckmarkImageView()
        setupTypeTasteLabel()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupIdLabel() {
        idLabel.font = UIFont.appFont(size: 18, weight: .regular)
        idLabel.numberOfLines = 1
        idLabel.textAlignment = .center
        contentView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    private func setupTasteLabel() {
        tasteLabel.font = UIFont.appFont(size: 20, weight: .medium)
        tasteLabel.numberOfLines = 0
        contentView.addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.0)
            make.leading.equalTo(idLabel.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    private func setupCheckmarkImageView() {
        checkmarkImageView.image = R.image.checkmark()
        checkmarkImageView.isHidden = true
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
        }
    }
    private func setupTypeTasteLabel() {
        typeTasteLabel.font = UIFont.appFont(size: 16, weight: .light)
        typeTasteLabel.numberOfLines = 1
        typeTasteLabel.textAlignment = .right
        contentView.addSubview(typeTasteLabel)
        typeTasteLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(tasteLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(8).priority(.medium)
            typeLabelTrainingConstraint = make.trailing.equalTo(checkmarkImageView.snp.leading).inset(-8).constraint
        }
    }

    // MARK: - ConfigurableCell
    func configure(with viewModel: AddTastesTableCellViewModel) {
        idLabel.text = viewModel.id
        tasteLabel.text = viewModel.taste
        typeTasteLabel.text = viewModel.typeTaste
        checkmarkImageView.isHidden = !viewModel.isSelect
        typeLabelTrainingConstraint?.isActive = viewModel.isSelect
    }
}
