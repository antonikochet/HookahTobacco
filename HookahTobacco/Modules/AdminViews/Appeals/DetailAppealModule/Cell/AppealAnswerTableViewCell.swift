//
//
//  AppealAnswerTableViewCell.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import UIKit
import TableKit

struct AppealAnswerTableViewCellItem {
    let anwser: String
    let isEnableSaveButton: Bool
    let touchSaveAnswer: CompletionBlockWithParam<String>
}

final class AppealAnswerTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - Private properties
    private var item: AppealAnswerTableViewCellItem?

    // MARK: - UI properties
    private let anwserTextView = AddTextView()
    private let saveButton = ApplyButton(style: .secondary)

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
        setupAnwserTextView()
        setupSaveButton()
    }
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupAnwserTextView() {
        anwserTextView.setupView(textLabel: R.string.localizable.detailAppealAnswerTitle())
        contentView.addSubview(anwserTextView)
        anwserTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    private func setupSaveButton() {
        saveButton.setTitle(R.string.localizable.detailAppealSaveAnswerTitle(), for: .normal)
        saveButton.action = { [weak self] in
            guard let self else { return }
            self.item?.touchSaveAnswer(self.anwserTextView.text)
        }
        contentView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(anwserTextView.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16.0).priority(999)
        }
    }

    // MARK: - Private methods

    // MARK: - ConfigurableCell
    func configure(with item: AppealAnswerTableViewCellItem) {
        self.item = item
        anwserTextView.text = item.anwser
        saveButton.isEnabled = item.isEnableSaveButton
    }

    // MARK: - Selectors
}
