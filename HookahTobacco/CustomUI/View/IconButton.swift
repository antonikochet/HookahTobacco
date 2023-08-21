//
//  IconButton.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//

import UIKit
import SnapKit

final class IconButton: UIView {
    // MARK: - Public properties
    public var action: CompletionBlock?

    public var buttonSize: CGFloat = 24.0 {
        didSet {
            snp.updateConstraints { make in
                make.size.equalTo(buttonSize)
            }
        }
    }

    public var imageSize: CGFloat = 24.0 {
        didSet {
            imageView.snp.updateConstraints { make in
                make.size.equalTo(imageSize < buttonSize ? imageSize : buttonSize)
            }
        }
    }

    public var imageColor: UIColor = .black {
        didSet {
            imageView.image = imageView.image?.withTintColor(imageColor, renderingMode: .alwaysOriginal)
        }
    }

    public var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue?.withTintColor(imageColor, renderingMode: .alwaysOriginal)
        }
    }

    // MARK: - private UI
    private var imageView: UIImageView = UIImageView()

    // MARK: - Private properties

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        setupView()
        setupImageView()
    }
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        addGestureRecognizer(tap)
        backgroundColor = .clear

        snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
        }
    }
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(imageSize)
        }
    }

    // MARK: - Public methods
    func createCornerRadius(_ radius: CGFloat? = nil) {
        let newRadius: CGFloat
        if let radius {
            newRadius = radius
        } else {
            newRadius = buttonSize / 2.0
        }
        layer.cornerRadius = newRadius
        clipsToBounds = true
    }

    // MARK: - Selectors
    @objc private func tapPressed() {
        action?()
    }
}
