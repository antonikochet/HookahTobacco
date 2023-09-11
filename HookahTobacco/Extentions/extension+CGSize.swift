//
//  extension+CGSize.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.09.2023.
//

import UIKit

extension CGSize {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width,
               height: lhs.height + rhs.height)
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    static func + (size: Self, edges: UIEdgeInsets) -> Self {
        CGSize(width: size.width + edges.left + edges.right,
               height: size.height + edges.top + edges.bottom)
    }
}
