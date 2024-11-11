//
//  extension+UIFont.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 11.11.2024.
//

import UIKit
import SwiftUI

extension UIFont {
    public static func appFont(size sizeFont: CGFloat, weight weightFont: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: sizeFont, weight: weightFont)
    }
}

extension Font {
    public static func appFont(size sizeFont: CGFloat, weight weightFont: Font.Weight) -> Font {
        Font.system(size: sizeFont, weight: weightFont)
    }
}
