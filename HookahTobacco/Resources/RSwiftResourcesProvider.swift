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
    public var colorUIKit: UIColor? {
        .init(resource: self)
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
        case .close:
            R.image.close
        }
    }
    
    func color(forKey key: ColorKeys) -> ColorResourceProtocol {
        switch key {
        case .primaryTitle:
            R.color.primaryTitle
        case .primarySubtitle:
            R.color.primarySubtitle
        case .secondarySubtitle:
            R.color.secondarySubtitle
        case .primaryBackground:
            R.color.primaryBackground
        case .secondaryBackground:
            R.color.secondaryBackground
        case .thirdBackground:
            R.color.thirdBackground
        case .fourthBackground:
            R.color.fourthBackground
        case .inputBackground:
            R.color.inputBackground
        case .primaryWhite:
            R.color.primaryWhite
        case .primaryBlack:
            R.color.primaryBlack
        case .primaryPurple:
            R.color.primaryPurple
        case .secondaryPurple:
            R.color.secondaryPurple
        case .primaryRed:
            R.color.primaryRed
        }
    }
}
