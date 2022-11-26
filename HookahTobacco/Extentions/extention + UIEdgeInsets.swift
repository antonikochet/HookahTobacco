//
//  extention + UIEdgeInsets.swift
//  HookahTobacco
//
//  Created by антон кочетков on 14.11.2022.
//

import UIKit

extension UIEdgeInsets {
    init(_ padding: CGFloat) {
        self.init(top: padding,
                  left: padding,
                  bottom: padding,
                  right: padding)
    }

    init(left: CGFloat, right: CGFloat) {
        self.init(top: 0,
                  left: left,
                  bottom: 0,
                  right: right)
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical,
                  left: horizontal,
                  bottom: vertical,
                  right: horizontal)
    }
}
