//
//  extention + UIButton.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.10.2022.
//

import UIKit

extension UIButton {
    static func createAppBigButton(_ text: String? = nil,
                                   image: UIImage? = nil,
                                   titleColol: UIColor = .white,
                                   backgroundColor: UIColor = .orange,
                                   adjustsFontSize: Bool = true,
                                   minimumScaleFactor: CGFloat = 0.8,
                                   fontSise: CGFloat = 20) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(titleColol, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = titleColol
        button.backgroundColor = backgroundColor
        button.titleLabel?.adjustsFontSizeToFitWidth = adjustsFontSize
        button.titleLabel?.minimumScaleFactor = minimumScaleFactor
        button.titleLabel?.font = UIFont.appFont(size: fontSise, weight: .bold)
        return button
    }

    func createCornerRadius() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
