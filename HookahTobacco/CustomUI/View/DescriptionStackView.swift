//
//  DescriptionStackView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.01.2023.
//

import UIKit
import SnapKit

struct DescriptionStackViewItem {
    let name: String
    let description: String
}

final class DescriptionStackView: UIView {

    // MARK: - Private UI
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setup() {
        setupView()
        setupNameLabel()
        setupDescriptionLabel()
        setupStackView()
    }

    private func setupView() {
        backgroundColor = .clear
    }
    private func setupNameLabel() {
        nameLabel.font = Fonts.name
        nameLabel.numberOfLines = 0
        nameLabel.textColor = Colors.nameText
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping

        stackView.addArrangedSubview(nameLabel)
    }
    private func setupDescriptionLabel() {
        descriptionLabel.font = Fonts.desctiption
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Colors.descriptionText
        descriptionLabel.textAlignment = .right
        descriptionLabel.lineBreakMode = .byWordWrapping

        stackView.addArrangedSubview(descriptionLabel)
    }
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutValues.StackView.spacing

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configure
    func configure(with item: DescriptionStackViewItem) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
    }
}

private struct LayoutValues {
    struct StackView {
        static let spacing: CGFloat = 4.0
    }
}
private struct Colors {
    static let nameText = UIColor(white: 0.07, alpha: 1.0)
    static let descriptionText = UIColor(white: 0.07, alpha: 1.0)
}
private struct Fonts {
    static let name = UIFont.appFont(size: 16.0, weight: .regular)
    static let desctiption = UIFont.appFont(size: 16.0, weight: .light)
}
