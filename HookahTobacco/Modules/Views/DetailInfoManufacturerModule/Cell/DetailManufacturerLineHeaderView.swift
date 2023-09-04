//
//  DetailInfoManufacturerTobaccoLineTableViewHeaderView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.01.2023.
//

import UIKit
import SnapKit

struct DetailManufacturerLineHeaderViewModel {
    let name: String
    let description: String
    let isHideTobacco: Bool

    var pressedHideTobaccoButton: ((String) -> Void)?
}

final class DetailManufacturerLineHeaderView: UIView {
    // MARK: - Private properties
    private var viewModel: DetailManufacturerLineHeaderViewModel?

    // MARK: - UI properties
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let button = IconButton()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setup() {
        setupContainerView()
        setupLabel()
        setupDescriptionLabel()
        setupButton()
    }
    private func setupContainerView() {
        containerView.backgroundColor = R.color.thirdBackground()
        containerView.layer.cornerRadius = 12.0
        containerView.clipsToBounds = true

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(LayoutValues.ContainerView.horizPadding)
        }
    }
    private func setupLabel() {
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        nameLabel.textColor = R.color.primaryTitle()
        nameLabel.font = Fonts.nameLabel

        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutValues.Label.padding)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
        }
    }
    private func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = Fonts.descriptionLabel
        descriptionLabel.textColor = R.color.primarySubtitle()

        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(LayoutValues.DescriptionLabel.top)
            make.leading.trailing.equalToSuperview().inset(LayoutValues.DescriptionLabel.horizPadding)
            make.bottom.equalToSuperview().inset(LayoutValues.DescriptionLabel.bottom)
        }
    }
    private func setupButton() {
        button.action = { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            viewModel.pressedHideTobaccoButton?(viewModel.name)
        }
        button.image = R.image.chevronDown()
        button.imageColor = R.color.primarySubtitle()

        containerView.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(LayoutValues.Label.horizPadding)
        }
    }

    func configure(with viewModel: DetailManufacturerLineHeaderViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        configureButton(with: viewModel)
    }
    private func configureButton(with viewModel: DetailManufacturerLineHeaderViewModel) {
        button.image = viewModel.isHideTobacco ? R.image.chevronUp() : R.image.chevronDown()
    }

    // MARK: - Selectors
}

struct DetailManufacturerLineHeaderCalculator {
    static func calculateHeightView(width: CGFloat,
                                    with viewModel: DetailManufacturerLineHeaderViewModel) -> CGFloat {
        var height: CGFloat = 0.0
        height += LayoutValues.Label.padding
        height += Fonts.nameLabel.lineHeight
        height += LayoutValues.DescriptionLabel.top
        let descriptionWidth = (width -
                                LayoutValues.ContainerView.horizPadding * 2.0 -
                                LayoutValues.DescriptionLabel.horizPadding * 2.0)
        height += viewModel.description.height(width: descriptionWidth, font: Fonts.descriptionLabel)
        height += LayoutValues.DescriptionLabel.bottom
        return height
    }
}

private struct LayoutValues {
    struct ContainerView {
        static let horizPadding: CGFloat = 8.0
    }
    struct Label {
        static let padding: CGFloat = 10.0
        static let horizPadding: CGFloat = 16.0
    }
    struct DescriptionLabel {
        static let top: CGFloat = 8.0
        static let bottom: CGFloat = 10.0
        static let horizPadding: CGFloat = 16.0
    }
}
private struct Fonts {
    static let nameLabel = UIFont.appFont(size: 20.0, weight: .medium)
    static let descriptionLabel = UIFont.appFont(size: 16.0, weight: .regular)
}
