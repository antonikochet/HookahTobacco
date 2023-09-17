//
//  extension+UITextField.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//

import UIKit

extension UITextField {

    enum PaddingPosition {
        case left
        case right
    }

    func createPaddingView(_ padding: CGFloat, in position: PaddingPosition, with mode: ViewMode) {
        let rect = CGRect(x: 0,
                          y: 0,
                          width: padding,
                          height: padding)
        let view = UIView(frame: rect)
        switch position {
        case .left:
            leftView = view
            leftViewMode = mode
        case .right:
            rightView = view
            rightViewMode = mode
        }
    }
}
