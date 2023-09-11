//
//  IconButton.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//

import UIKit
import SnapKit

final class IconButton: IconView {
    // MARK: - Public properties
    public var action: CompletionBlock?

    // MARK: - Init
    override init() {
        super.init()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        addGestureRecognizer(tap)
    }

    // MARK: - Selectors
    @objc private func tapPressed() {
        action?()
    }
}
