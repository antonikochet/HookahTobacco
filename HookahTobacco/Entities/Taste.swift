//
//  Taste.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//

import Foundation

struct Taste {
    var id: String = ""
    let uid: Int
    let taste: String
    let typeTaste: String
}

extension Taste: Hashable {
    static func == (_ lhs: Taste, rhs: Taste) -> Bool {
        lhs.uid == rhs.uid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
