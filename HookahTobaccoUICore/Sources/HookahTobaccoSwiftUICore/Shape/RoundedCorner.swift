//
//  RoundedCorner.swift
//
//
//  Created by Антон Кочетков on 15.11.2024.
//

import SwiftUI

public struct RoundedCorner: Shape {
    private let radius: CGFloat
    private let corners: UIRectCorner

    public init(
        radius: CGFloat, 
        corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
