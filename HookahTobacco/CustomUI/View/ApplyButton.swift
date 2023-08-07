//
//  ApplyButton.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit

final class ApplyButton: UIButton {
    var action: CompletionBlock?

    override var intrinsicContentSize: CGSize {
        CGSize(width: 100, height: 44)
    }

    override var isEnabled: Bool {
        didSet {
            setbackgroundColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = intrinsicContentSize.height / 2.0
        titleLabel?.font = UIFont.appFont(size: 18, weight: .semibold)
        titleLabel?.adjustsFontSizeToFitWidth = true
        backgroundColor = .orange
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    @objc private func buttonAction() {
        action?()
    }

    private func setbackgroundColor() {
        if !isEnabled {
            backgroundColor = .systemGray4
            return
        }

        backgroundColor = isHighlighted ? .orange.withAlphaComponent(0.6) : .orange
    }
}
