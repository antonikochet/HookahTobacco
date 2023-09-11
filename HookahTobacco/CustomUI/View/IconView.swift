//
//  IconView.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.09.2023.
//

import UIKit
import SnapKit

class IconView: UIView {
    // MARK: - Public properties
    public var size: CGFloat = 24.0 {
        didSet {
            snp.updateConstraints { make in
                make.size.equalTo(size)
            }
        }
    }

    public var imageSize: CGFloat = 24.0 {
        didSet {
            imageView.snp.updateConstraints { make in
                make.size.equalTo(imageSize < size ? imageSize : size)
            }
        }
    }

    public var imageColor: UIColor? = .clear {
        didSet {
            imageView.image = imageView.image?.withTintColor(imageColor ?? .black, renderingMode: .alwaysOriginal)
        }
    }

    public var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    // MARK: - private UI
    private var imageView: UIImageView = UIImageView()

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
        backgroundColor = .clear

        snp.makeConstraints { make in
            make.size.equalTo(size)
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
            newRadius = size / 2.0
        }
        layer.cornerRadius = newRadius
        clipsToBounds = true
    }
}
