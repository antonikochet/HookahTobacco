//
//  extension+UIFont.swift
//  
//
//  Created by антон кочетков on 15.09.2022.
//

import UIKit

extension UIFont {
    public static func appFont(size sizeFont: CGFloat, weight weightFont: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: sizeFont, weight: weightFont)
    }
}
