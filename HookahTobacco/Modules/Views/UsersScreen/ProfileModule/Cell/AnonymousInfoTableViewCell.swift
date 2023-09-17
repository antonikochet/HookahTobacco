//
//
//  AnonymousInfoTableViewCell.swift
//  HookahTobacco
//
//  Created by антон кочетков on 06.01.2023.
//
//

import UIKit
import TableKit

struct AnonymousInfoTableViewCellItem {
    var text: String
}

final class AnonymousInfoTableViewCell: UITableViewCell, ConfigurableCell {
    // MARK: - Public properties

    // MARK: - UI properties
    private let infoLabel = UILabel()

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
        setupInfoLabel()
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    private func setupInfoLabel() {
        infoLabel.textColor = Colors.text
        infoLabel.font = Fonts.label
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0

        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutValues.padding)
        }
    }

    // MARK: - ConfigurableCell
    func configure(with item: AnonymousInfoTableViewCellItem) {
        infoLabel.text = item.text
    }
}

private struct LayoutValues {
    static let padding: CGFloat = 16.0
}
private struct Colors {
    static let text = UIColor(white: 0.2, alpha: 1.0)
}
private struct Fonts {
    static let label = UIFont.appFont(size: 14, weight: .regular)
}
