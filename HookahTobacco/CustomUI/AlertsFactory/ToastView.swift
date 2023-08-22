//
//  ToastView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.12.2022.
//

import UIKit
import SnapKit

final class ToastView: UIView {
    // MARK: - Public properties
    enum PositionView {
        case topAboveNavBar
        case top
        case center
        case bottom
    }

    var durationAnimate: Double = 0.5
    var cornerRadius: CGFloat = 16.0
    var positionViewOnSuperView: PositionView = .top

    // MARK: - Private properties
    private let paddingView: CGFloat = 8.0

    // MARK: - Private UI
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setups
    private func setupUI() {
        setupView()
        configureBlurView()
        setupIconImageView()
        setupTitleLabel()
        setupMessageLabel()
    }
    private func setupView() {
        alpha = 0.0
        layer.cornerRadius = cornerRadius
        backgroundColor = .clear
        layer.masksToBounds = true
    }
    private func configureBlurView() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect())
        blurView.layer.cornerRadius = layer.cornerRadius
        blurView.frame = bounds
        blurView.blurRadius = 2
        blurView.effectBackgroundColor = UIColor(white: 0.2, alpha: 0.9)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(0)
        }
    }
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.font = UIFont.appFont(size: 20, weight: .semibold)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12.0)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12.0)
        }
    }
    private func setupMessageLabel() {
        messageLabel.textAlignment = .left
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.font = UIFont.appFont(size: 16.0, weight: .regular)
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12.0)
            make.trailing.bottom.equalToSuperview().inset(12.0)
        }
    }

    // MARK: - Public methods
    class func createView(superview: UIView) -> ToastView {
        let toastView = ToastView(frame: .zero)

        superview.addSubview(toastView)
        superview.bringSubviewToFront(toastView)

        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }

        return toastView
    }

    func showErrorToast(title: String? = nil, message: String, delay: Double) {
        showToast(title: title,
                  message: message,
                  delay: delay,
                  isShowIcon: true,
                  isSuccess: false)
    }

    func showToast(title: String? = nil, message: String, delay: Double, isShowIcon: Bool = false) {
        showToast(title: title,
                  message: message,
                  delay: delay,
                  isShowIcon: isShowIcon,
                  isSuccess: true)
    }

    // MARK: - Private methods
    private func showToast(title: String?,
                           message: String,
                           delay: Double,
                           isShowIcon: Bool = false,
                           isSuccess: Bool = false) {
        guard let superview else { return }
        let width = superview.frame.width - paddingView * 2
        if let title, !title.isEmpty {
            titleLabel.text = title
        } else {
            titleLabel.snp.updateConstraints { $0.top.equalTo(0.0) }
            messageLabel.snp.updateConstraints { $0.top.equalTo(titleLabel.snp.bottom).offset(12.0) }
        }
        iconImageView.isHidden = !isShowIcon
        iconImageView.image = isSuccess ? UIImage(named: "toastOk") : UIImage(named: "toastError")
        iconImageView.snp.updateConstraints { make in
            make.size.equalTo(isShowIcon ? 24.0 : 0)
            make.leading.equalTo(isShowIcon ? 12.0 : 0)
        }

        messageLabel.text = message

        makeConstraintsPosition()
        snp.makeConstraints { $0.width.equalTo(width) }
        UIView.animate(withDuration: TimeInterval(durationAnimate), delay: 0) {
            self.alpha = 1.0
            self.layoutIfNeeded()
        } completion: { completion in
            if completion {
                self.hide(delay: delay)
            }
        }
    }

    private func hide(delay: Double) {
        UIView.animate(withDuration: TimeInterval(durationAnimate),
                       delay: TimeInterval(delay)) {
            self.alpha = 0
        } completion: { isCompletion in
            if isCompletion {
                self.removeFromSuperview()
            }
        }
    }

    private func makeConstraintsPosition() {
        let topNavBarPadding: CGFloat = superview?.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        switch positionViewOnSuperView {
        case .topAboveNavBar:
            snp.makeConstraints { $0.top.equalTo(superview!.snp.top).offset(topNavBarPadding) }
        case .top:
            snp.makeConstraints { $0.top.equalTo(superview!.safeAreaLayoutGuide.snp.top).offset(paddingView) }
        case .center:
            snp.makeConstraints { $0.centerY.equalToSuperview() }
        case .bottom:
            snp.makeConstraints { $0.bottom.equalTo(superview!.safeAreaLayoutGuide.snp.bottom).inset(paddingView) }
        }
    }
}
