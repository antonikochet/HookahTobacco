//
//  Taste.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//

import Foundation

struct Taste {
    var id: String = ""
    var uid: Int = -1
    let taste: String
    let typeTaste: [TasteType]
}

extension Taste: Hashable {
    static func == (_ lhs: Taste, rhs: Taste) -> Bool {
        lhs.uid == rhs.uid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
