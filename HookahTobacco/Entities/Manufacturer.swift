//
//  Manufacturer.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation

struct Manufacturer {
    var uid: String?
    let name: String
    let country: String
    let description: String
    var nameImage: String
    var image: Data?
    let link: String?
}

extension Manufacturer: Equatable {
    static func ==(lm: Manufacturer, rm: Manufacturer) -> Bool {
        lm.name == rm.name
    }
}
