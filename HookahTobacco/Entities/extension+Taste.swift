//
//  extension+Taste.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//

import HookahTobaccoCore

extension Taste: Hashable {
    public static func == (_ lhs: Taste, rhs: Taste) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
