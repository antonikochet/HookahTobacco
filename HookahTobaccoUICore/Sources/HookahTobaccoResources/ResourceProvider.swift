//
//  ResourceProvider.swift
//
//
//  Created by Антон Кочетков on 11.11.2024.
//

import UIKit
import SwiftUI

public protocol ImageResourceProtocol {
    var imageUIKit: UIImage { get }
    var imageSwiftUI: Image { get }
}

public protocol ColorResourceProtocol {
    var colorUIKit: UIColor? { get }
    var colorSwiftUI: Color { get }
}

public protocol ResourceProvider {
    func image(forKey key: ImageKeys) -> ImageResourceProtocol
    func color(forKey key: ColorKeys) -> ColorResourceProtocol
}

public enum ResourceManager {
    public static var provider: ResourceProvider! = MockResourceProvider()
}

internal struct MockImageResource: ImageResourceProtocol {
    var imageUIKit: UIImage {
        UIImage()
    }
    
    var imageSwiftUI: Image {
        Image("")
    }
}

internal struct MockColorResource: ColorResourceProtocol {
    
    private let color: UIColor
    
    init(key: ColorKeys) {
        switch key {
        case .primaryTitle:
            self.color = .label
        case .primarySubtitle:
            self.color = .label
        case .secondarySubtitle:
            self.color = .secondaryLabel
        case .primaryBackground:
            self.color = .systemBackground
        case .secondaryBackground:
            self.color = .secondarySystemBackground
        case .thirdBackground:
            self.color = .tertiarySystemBackground
        case .fourthBackground:
            self.color = .tertiarySystemBackground
        case .inputBackground:
            self.color = .systemGray6
        case .primaryWhite:
            self.color = .white
        case .primaryBlack:
            self.color = .black
        case .primaryPurple:
            self.color = .purple
        case .secondaryPurple:
            self.color = .purple.withAlphaComponent(0.9)
        case .primaryRed:
            self.color = .red
        case .primaryGreen:
            self.color = .green
        }
    }
    
    var colorUIKit: UIColor? {
        color
    }
    
    var colorSwiftUI: Color {
        Color(uiColor: color)
    }
}

internal struct MockResourceProvider: ResourceProvider {
    func image(forKey key: ImageKeys) -> ImageResourceProtocol {
        MockImageResource()
    }
    
    func color(forKey key: ColorKeys) -> ColorResourceProtocol {
        MockColorResource(key: key)
    }
}
