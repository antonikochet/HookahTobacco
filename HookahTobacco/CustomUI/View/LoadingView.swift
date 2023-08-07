//
//  LoadingView.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit

final class LoadingView: UIView {
    // MARK: - Public properties
    var cornerRadius: CGFloat {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    var activityIndicatorColor: UIColor = .white {
        didSet {
            activityIndicator.color = activityIndicatorColor
        }
    }

    var blurBackgroundColor: UIColor = UIColor(red: 47.0/255.0, green: 41.0/255.0, blue: 41.0/255.0, alpha: 1.0) {
        didSet {
            if isBlur {
                blurView.effectBackgroundColor = blurBackgroundColor
            }
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 80)
    }

    // MARK: - Private properties
    private let isBlur: Bool

    // MARK: - Private UI
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect())

    init(isBlur: Bool,
         cornerRadius: CGFloat = 16.0) {
        self.isBlur = isBlur
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setup() {
        setupView()
        setupBlurView()
        setupActivityIndicator()
    }
    private func setupView() {
        backgroundColor = UIColor(red: 47.0/255.0, green: 41.0/255.0, blue: 41.0/255.0, alpha: 0.7)
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
    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
