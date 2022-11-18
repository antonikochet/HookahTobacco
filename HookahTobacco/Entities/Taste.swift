//
//  Taste.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//

import Foundation

struct Taste {
    let id: Int
    let taste: String
    let typeTaste: String
}

extension Taste: Hashable {
    static func ==(_ lhs: Taste, rhs: Taste) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
