//
//  NamedFireStorage.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

enum TobaccoImageType: String {
    case main
}

enum NamedFireStorage {
    case manufacturerImage(name: String)
    case tobaccoImage(manufacturer: String, uid: String, type: TobaccoImageType)
    
    var path: String {
        switch self {
            case .manufacturerImage(let name) :
                return "manufacturerImage/\(name)"
            case .tobaccoImage(let manufacturer, let uid, let type):
                return "tobaccosImage/\(manufacturer)/\(type.rawValue)_\(uid).png"
        }
    }
}
