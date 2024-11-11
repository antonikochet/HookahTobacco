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
    var colorUIKit: UIColor? {
        .white
    }
    
    var colorSwiftUI: Color {
        .white
    }
}

internal struct MockResourceProvider: ResourceProvider {
    func image(forKey key: ImageKeys) -> ImageResourceProtocol {
        MockImageResource()
    }
    
    func color(forKey key: ColorKeys) -> ColorResourceProtocol {
        MockColorResource()
    }
}
