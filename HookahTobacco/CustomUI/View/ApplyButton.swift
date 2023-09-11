//
//  ApplyButton.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit

final class ApplyButton: UIButton {

    // MARK: - Private properties
    private var style: Style

    // MARK: - Public properties
    var action: CompletionBlock?

    override var intrinsicContentSize: CGSize {
        CGSize(width: 300, height: 50)
    }

    override var isEnabled: Bool {
        didSet {
            setbackgroundColor()
        }
    }

    // MARK: - Init
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = intrinsicContentSize.height / 2.0
        titleLabel?.font = UIFont.appFont(size: 20, weight: .semibold)
        titleLabel?.adjustsFontSizeToFitWidth = true
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    // MARK: - Public methods
    func applyStyle(_ style: ApplyButton.Style) {
        self.style = style
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
    }

    // MARK: - Private methods
    private func setbackgroundColor() {
        if !isEnabled {
            backgroundColor = R.color.fourthBackground()
            return
        }

        backgroundColor = style.backgroundColor
    }

    // MARK: - Selectors
    @objc private func buttonAction() {
        action?()
    }
}

extension ApplyButton {
    enum Style {
        case primary
        case secondary

        var backgroundColor: UIColor? {
            switch self {
            case .primary:
                return R.color.primaryPurple()
            case .secondary:
                return R.color.secondaryPurple()
            }
        }

        var textColor: UIColor? {
            switch self {
            case .primary:
                return R.color.primaryWhite()
            case .secondary:
                return R.color.primaryWhite()
            }
        }
    }
}
