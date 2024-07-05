//
//  NamedImageStorage.swift
//  HookahTobacco
//
//  Created by антон кочетков on 24.11.2022.
//

import Foundation

enum NamedImageStorage: ImageStorageServiceDataProtocol {
    case manufacturer(nameImage: String)
    case tobacco(manufacturer: String, name: String)

    var directories: String {
        switch self {
        case .manufacturer: return "manufacturer"
        case .tobacco(let manufacturer, _): return "tobaccos/\(manufacturer)"
        }
    }

    var nameFile: String {
        switch self {
        case .manufacturer(let nameImage): return nameImage
        case .tobacco(_, let name): return name
        }
    }
}
