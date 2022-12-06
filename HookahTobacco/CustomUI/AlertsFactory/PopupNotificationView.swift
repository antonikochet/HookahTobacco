//
//  PopupNotificationView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.12.2022.
//

import UIKit
import SnapKit

final class PopupNotificationView: UIView {
    // MARK: - Public properties
    enum NotificationType {
        case success(message: String)
        case error(message: String)
    }

    enum PositionView {
        case top
        case center
        case bottom
    }

    var durationAnimate: Double = 0.5
    var successBackgroundColor: UIColor = .systemGreen
    var successTintColor: UIColor = .black
    var errorBackgroundColor: UIColor = .systemRed
    var errorTintColor: UIColor = .white
    var fontText: UIFont = UIFont.appFont(size: 20, weight: .medium)
    var positionViewOnSuperView: PositionView = .bottom
    // MARK: - Private properties
    private let paddingLabel: CGFloat = 10
    private let paddingView: CGFloat = 16

    // MARK: - Private UI
    private let label = UILabel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setups
    private func setup() {
        alpha = 0.0
        layer.cornerRadius = 16

        addSubview(label)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(paddingLabel)
        }
    }

    // MARK: - Public methods
    class func createView(superview: UIView) -> PopupNotificationView {
        let notificationView = PopupNotificationView(frame: .zero)

        superview.addSubview(notificationView)
        superview.bringSubviewToFront(notificationView)

        notificationView.snp.makeConstraints { make in
            make.size.equalTo(0)
            make.centerX.equalToSuperview()
        }

        return notificationView
    }

    func show(_ type: PopupNotificationView.NotificationType, delay: Double) {
        guard let superview = superview else { return }
        var size = CGSize()
        let width = superview.frame.width - (paddingView + paddingLabel) * 2
        switch type {
        case .success(let message):
                size = CGSize(width: width, height: message.height(width: width, font: fontText))
                label.text = message
                backgroundColor = successBackgroundColor
                label.textColor = successTintColor
        case .error(let message):
                size = CGSize(width: width, height: message.height(width: width, font: fontText))
                label.text = message
                backgroundColor = errorBackgroundColor
                label.textColor = errorTintColor
        }
        makeConstraintsPosition()
        size = CGSize(width: size.width,
                      height: size.height + paddingLabel * 2)
        snp.updateConstraints { $0.size.equalTo(size) }
        UIView.animate(withDuration: TimeInterval(durationAnimate), delay: 0) {
            self.alpha = 1.0
            self.layoutIfNeeded()
        } completion: { completion in
            if completion {
                self.hide(delay: delay)
            }
        }
    }

    // MARK: - Private methods
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
        switch positionViewOnSuperView {
        case .top:
            snp.makeConstraints { $0.top.equalTo(superview!.safeAreaLayoutGuide.snp.top).offset(60) }
        case .center:
            snp.makeConstraints { $0.centerY.equalToSuperview() }
        case .bottom:
            snp.makeConstraints { $0.bottom.equalTo(superview!.safeAreaLayoutGuide.snp.bottom).inset(60) }
        }
    }
}
