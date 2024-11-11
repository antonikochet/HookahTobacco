//
//  RSwiftResourcesProvider.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 11.11.2024.
//

import UIKit
import SwiftUI
import HookahTobaccoResources
import RswiftResources

extension RswiftResources.ImageResource: ImageResourceProtocol {
    public var imageUIKit: UIImage {
        .init()
    }
    
    public var imageSwiftUI: Image {
        Image(name)
    }
}

extension RswiftResources.ColorResource: ColorResourceProtocol {
    public var colorUIKit: UIColor {
        .init()
    }
    
    public var colorSwiftUI: Color {
        Color(name)
    }
}

struct RSwiftResourcesProvider: ResourceProvider {
    func image(forKey key: ImageKeys) -> ImageResourceProtocol {
        switch key {
        case .notFound:
            R.image.notFound
        }
    }
    
    func color(forKey key: ColorKeys) -> ColorResourceProtocol {
        switch key {
        case .primaryTitle:
            R.color.primaryTitle
        case .primarySubtitle:
            R.color.primarySubtitle
        }
    }
}
