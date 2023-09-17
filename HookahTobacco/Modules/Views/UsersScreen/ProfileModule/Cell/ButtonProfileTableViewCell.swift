//
//
//  ButtonProfileTableViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.01.2023.
//
//

import UIKit
import TableKit

struct ButtonProfileTableViewCellItem {
    let text: String
    let buttonAction: CompletionBlock?
}

final class ButtonProfileTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties
    var item: ButtonProfileTableViewCellItem?

    // MARK: - UI properties
    private let button = ApplyButton(style: .primary)

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Override

    // MARK: - Setup UI
    private func setupUI() {
        setupCell()
        setupButton()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func setupButton() {
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: ButtonProfileTableViewCellItem) {
        self.item = item
        button.setTitle(item.text, for: .normal)
        button.action = { [weak self] in
            self?.item?.buttonAction?()
        }
    }

    static var estimatedHeight: CGFloat? {
        64.0
    }

    // MARK: - Selectors

}
