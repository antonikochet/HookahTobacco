//
//  DescriptionStackView.swift
//  
//
//  Created by Антон Кочетков on 11.11.2024.
//

import UIKit
import HookahTobaccoResources

public struct DescriptionStackViewItem {
    public let name: String
    public let description: String
    
    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

public final class DescriptionStackView: UIView {

    // MARK: - Private UI
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder: NSCoder) {
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

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configure
    public func configure(with item: DescriptionStackViewItem) {
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
    static let nameText = ResourceManager.provider.color(forKey: .primaryTitle).colorUIKit
    static let descriptionText: UIColor = ResourceManager.provider.color(forKey: .primarySubtitle).colorUIKit
}
private struct Fonts {
    static let name = UIFont.appFont(size: 16.0, weight: .regular)
    static let desctiption = UIFont.appFont(size: 16.0, weight: .light)
}
