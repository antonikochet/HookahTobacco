//
//  ApplyButton.swift
//
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit
import HookahTobaccoResources

public final class ApplyButton: UIButton {

    // MARK: - Private properties
    private var style: Style

    // MARK: - Public properties
    public var action: VoidBlock?

    public override var intrinsicContentSize: CGSize {
        CGSize(width: 300, height: 50)
    }

    public override var isEnabled: Bool {
        didSet {
            setbackgroundColor()
        }
    }

    // MARK: - Init
    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
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
    public func applyStyle(_ style: ApplyButton.Style) {
        self.style = style
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
    }

    // MARK: - Private methods
    private func setbackgroundColor() {
        if !isEnabled {
            backgroundColor = ResourceManager.provider.color(forKey: .fourthBackground).colorUIKit
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
    public enum Style {
        case primary
        case secondary

        var backgroundColor: UIColor? {
            switch self {
            case .primary:
                return ResourceManager.provider.color(forKey: .primaryPurple).colorUIKit
            case .secondary:
                return ResourceManager.provider.color(forKey: .secondaryPurple).colorUIKit
            }
        }

        var textColor: UIColor? {
            switch self {
            case .primary:
                return ResourceManager.provider.color(forKey: .primaryWhite).colorUIKit
            case .secondary:
                return ResourceManager.provider.color(forKey: .primaryWhite).colorUIKit
            }
        }
    }
}
