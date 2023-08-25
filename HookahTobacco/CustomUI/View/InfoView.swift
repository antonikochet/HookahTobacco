//
//  InfoView.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import SnapKit
import UIKit

struct InfoViewModel {
    let image: UIImage?
    let title: String
    let subtitle: String?
    let primaryAction: ActionWithTitle?
    let secondaryAction: ActionWithTitle?

    var topView: UIView?
    var bottomView: UIView?

    init(image: UIImage?,
         title: String,
         subtitle: String?,
         primaryAction: ActionWithTitle?,
         secondaryAction: ActionWithTitle? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}

struct ActionWithTitle {
    let title: String
    let action: CompletionBlock

    init(title: String, action: @escaping CompletionBlock) {
        self.title = title
        self.action = action
    }
}

final class InfoView: UIView {
    private let imageViewHolder = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private lazy var buttonsStackView = UIStackView(arrangedSubviews: [primaryActionButton, secondaryActionButton])
    private let primaryActionButton = ApplyButton()
    private let secondaryActionButton = ApplyButton()
    private lazy var stackView = UIStackView(arrangedSubviews: [imageViewHolder, titleLabel, subtitleLabel])

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemBackground
        addSubview(stackView)
        stackView.axis = .vertical

        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16

        let bigPadding: CGFloat = UIScreen.main.bounds.width <= 667 ? 32 : 48
        stackView.setCustomSpacing(bigPadding, after: imageViewHolder)
        stackView.setCustomSpacing(16, after: titleLabel)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(bigPadding)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        imageViewHolder.addSubview(imageView)
        imageView.contentMode = .center
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 130
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.height.equalTo(259)
        }

        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        subtitleLabel.numberOfLines = 4
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .systemGray2
        subtitleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        primaryActionButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        secondaryActionButton.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)

        addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(stackView)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-32)
        }
    }

    func configure(viewModel: InfoViewModel) {
        imageView.isHidden = viewModel.image == nil
        imageView.image = viewModel.image

        titleLabel.text = viewModel.title

        subtitleLabel.isHidden = viewModel.subtitle == nil
        subtitleLabel.text = viewModel.subtitle

        primaryActionButton.isHidden = viewModel.primaryAction == nil
        primaryActionButton.setTitle(viewModel.primaryAction?.title, for: .normal)
        primaryActionButton.action = viewModel.primaryAction?.action

        secondaryActionButton.isHidden = viewModel.secondaryAction == nil
        secondaryActionButton.setTitle(viewModel.secondaryAction?.title, for: .normal)
        secondaryActionButton.action = viewModel.secondaryAction?.action
    }

    @objc private func primaryButtonTapped() {
        primaryActionButton.action?()
    }

    @objc private func secondaryButtonTapped() {
        secondaryActionButton.action?()
    }
}
