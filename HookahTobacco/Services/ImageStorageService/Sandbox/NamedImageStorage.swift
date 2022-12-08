//
//  NamedImageStorage.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation

enum NamedImageStorage: ImageStorageServiceDataProtocol {
    case manufacturer(nameImage: String)
    case tobacco(manufacturer: String, uid: String, type: TobaccoImageType)

    var directories: String {
        switch self {
        case .manufacturer: return "manufacturer"
        case .tobacco(let manufacturer, _, _): return "tobaccos/\(manufacturer)"
        }
    }

    var nameFile: String {
        switch self {
        case .manufacturer(let nameImage): return nameImage
        case .tobacco(_, let uid, let type): return "\(type.rawValue)_\(uid).png"
        }
    }
}
