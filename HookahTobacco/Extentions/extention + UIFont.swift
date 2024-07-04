//
//  extention + UIFont.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.09.2022.
//

import UIKit
import SwiftUI

extension UIFont {
    static func appFont(size sizeFont: CGFloat, weight weightFont: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: sizeFont, weight: weightFont)
    }
}

extension Font {
    static func appFont(size sizeFont: CGFloat, weight weightFont: Font.Weight) -> Font {
        Font.system(size: sizeFont, weight: weightFont)
    }
}
