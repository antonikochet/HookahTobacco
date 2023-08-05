//
//  PopupAlertView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 27.11.2022.
//

import UIKit
import SnapKit

final class PopupAlertView: UIView {
    // MARK: - Public properties
    enum AlertType {
        case success
        case error
    }

    var imageColor: UIColor = .systemBlue {
        didSet {
            imageView.tintColor = imageColor
        }
    }
    var durationAnimate: Double = 0.3
    var sizeAlertView: CGSize = CGSize(width: 75, height: 75)

    // MARK: - Private properties

    // MARK: - Private UI
    private let imageView = UIImageView()

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
        backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        alpha = 0.0
        layer.cornerRadius = 16

        addSubview(imageView)
        imageView.tintColor = imageColor
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    // MARK: - Public methods
    class func createView(superview: UIView) -> PopupAlertView {
        let alertView = PopupAlertView(frame: .zero)

        superview.addSubview(alertView)
        superview.bringSubviewToFront(alertView)
        alertView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(alertView.sizeAlertView)
        }

        return alertView
    }

    func show(_ type: PopupAlertView.AlertType, delay: Double, completion: (() -> Void)? = nil) {
        var image: UIImage?
        switch type {
        case .success:
            image = UIImage(systemName: "checkmark")
        case .error:
            image = UIImage(systemName: "multiply.circle")
        }
        imageView.image = image
        UIView.animate(withDuration: TimeInterval(durationAnimate), delay: 0) {
            self.alpha = 0.8
        } completion: { isCompletion in
            if isCompletion {
                self.hide(delay: delay, completion: completion)
            }
        }
    }

    // MARK: - Private methods
    private func hide(delay: Double, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: TimeInterval(durationAnimate),
                       delay: TimeInterval(delay),
                       options: []) {
            self.alpha = 0
        } completion: { isCompletion in
            if isCompletion {
                completion?()
                self.removeFromSuperview()
            }
            
        }
    }
}
