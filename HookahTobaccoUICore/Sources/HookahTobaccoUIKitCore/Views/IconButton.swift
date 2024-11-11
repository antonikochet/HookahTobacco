//
//  IconButton.swift
//  
//
//  Created by Anton Kochetkov on 06.08.2023.
//

import UIKit

public final class IconButton: IconView {
    // MARK: - Public properties
    public var action: VoidBlock?

    // MARK: - Init
    public override init() {
        super.init()
        setupAction()
    }

    public required init?(coder: NSCoder) {
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
