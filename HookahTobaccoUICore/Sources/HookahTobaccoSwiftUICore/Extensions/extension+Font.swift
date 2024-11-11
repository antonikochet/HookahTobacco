//
//  extension+Font.swift
//
//
//  Created by Антон Кочетков on 10.11.2024.
//

import SwiftUI

extension Font {
    public static func appFont(size sizeFont: CGFloat, weight weightFont: Font.Weight) -> Font {
        Font.system(size: sizeFont, weight: weightFont)
    }
}
