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
    private let button = UIButton()

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
        containerView.backgroundColor = Colors.ContainerView.background
        containerView.layer.cornerRadius = LayoutValues.ContainerView.cornerRadius
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
        nameLabel.font = Fonts.label

        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutValues.Label.padding)
            make.leading.equalToSuperview().offset(LayoutValues.Label.left)
            make.trailing.equalToSuperview().inset(LayoutValues.Label.trailing)
        }
    }
    private func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = Fonts.description
        descriptionLabel.textColor = Colors.DescriptionLabel.text

        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(LayoutValues.DescriptionLabel.padding)
            make.leading.equalToSuperview().offset(LayoutValues.DescriptionLabel.left)
            make.trailing.bottom.equalToSuperview().inset(LayoutValues.DescriptionLabel.padding)
        }
    }
    private func setupButton() {
        button.tintColor = Colors.Button.tint
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)

        containerView.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.size.equalTo(LayoutValues.Button.size)
            make.trailing.equalToSuperview().inset(LayoutValues.Button.trailing)
        }
    }

    func configure(with viewModel: DetailManufacturerLineHeaderViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        configureButton(with: viewModel)
    }
    private func configureButton(with viewModel: DetailManufacturerLineHeaderViewModel) {
        button.setImage(viewModel.isHideTobacco ? Images.up : Images.down, for: .normal)
    }

    // MARK: - Selectors
    @objc private func pressedButton() {
        guard let viewModel else { return }
        viewModel.pressedHideTobaccoButton?(viewModel.name)
    }
}

struct DetailManufacturerLineHeaderCalculator {
    static func calculateHeightView(width: CGFloat,
                                    with viewModel: DetailManufacturerLineHeaderViewModel) -> CGFloat {
        var height: CGFloat = 0.0
        height += LayoutValues.Label.padding
        height += Fonts.label.lineHeight
        height += LayoutValues.DescriptionLabel.padding
        let descriptionWidth = width - LayoutValues.DescriptionLabel.left - LayoutValues.DescriptionLabel.padding
        height += viewModel.description.height(width: descriptionWidth, font: Fonts.description)
        height += LayoutValues.DescriptionLabel.padding
        return height
    }
}

private struct LayoutValues {
    struct ContainerView {
        static let horizPadding: CGFloat = 16.0
        static let cornerRadius: CGFloat = 12.0
    }
    struct Label {
        static let left: CGFloat = 16.0
        static let padding: CGFloat = 8.0
        static let trailing: CGFloat = padding + Button.size + Button.trailing
    }
    struct DescriptionLabel {
        static let padding: CGFloat = 8.0
        static let left: CGFloat = 16.0
    }
    struct Button {
        static let size: CGFloat = 24.0
        static let trailing: CGFloat = 8.0
    }
}
private struct Images {
    static let up = UIImage(systemName: "chevron.up")!.withRenderingMode(.alwaysTemplate)
    static let down = UIImage(systemName: "chevron.down")!.withRenderingMode(.alwaysTemplate)
}
private struct Colors {
    struct ContainerView {
        static let background = UIColor(white: 0.8, alpha: 1.0)
    }
    struct Label {
        static let text = UIColor(white: 0.3, alpha: 1.0)
    }
    struct DescriptionLabel {
        static let text = UIColor(white: 0.35, alpha: 1.0)
    }
    struct Button {
        static let tint = UIColor(white: 0.35, alpha: 1.0)
    }
}
private struct Fonts {
    static let label = UIFont.appFont(size: 24.0, weight: .medium)
    static let description = UIFont.appFont(size: 16.0, weight: .regular)
}
