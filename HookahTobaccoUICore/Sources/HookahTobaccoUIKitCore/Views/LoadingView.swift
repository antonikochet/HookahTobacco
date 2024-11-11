//
//  LoadingView.swift
//  
//
//  Created by Антон Кочетков on 11.11.2024.
//

import UIKit
import HookahTobaccoResources

public final class LoadingView: UIView {
    // MARK: - Public properties
    public var cornerRadius: CGFloat {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    public var activityIndicatorColor: UIColor? = ResourceManager.provider.color(forKey: .primaryWhite).colorUIKit {
        didSet {
            activityIndicator.color = activityIndicatorColor
        }
    }

    public var blurBackgroundColor: UIColor? = ResourceManager.provider.color(forKey: .secondarySubtitle).colorUIKit {
        didSet {
            if isBlur {
                blurView.effectBackgroundColor = blurBackgroundColor
            }
        }
    }
    public override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 80)
    }

    // MARK: - Private properties
    private let isBlur: Bool

    // MARK: - Private UI
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect())

    public init(isBlur: Bool,
         cornerRadius: CGFloat = 16.0) {
        self.isBlur = isBlur
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setup() {
        setupView()
        setupBlurView()
        setupActivityIndicator()
    }
    private func setupView() {
        backgroundColor = ResourceManager.provider.color(forKey: .secondarySubtitle).colorUIKit
    }
    private func setupBlurView() {
        if isBlur {
            layer.masksToBounds = true
            backgroundColor = .clear
            layer.cornerRadius = cornerRadius

            addSubview(blurView)
            blurView.layer.cornerRadius = layer.cornerRadius
            blurView.frame = bounds
            blurView.blurRadius = 2
            blurView.effectBackgroundColor = blurBackgroundColor
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.color = activityIndicatorColor
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Public methods
    public func startLoading() {
        activityIndicator.startAnimating()
    }

    public func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
