//
//  NamedFireStorage.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.10.2022.
//

import Foundation

enum NamedFireStorage {
    case manufacturerImage(name: String)
    
    var path: String {
        switch self {
            case .manufacturerImage(let name) :
                return "manufacturerImage/\(name)"
        }
    }
}
