//
//  extension+TobaccoFilter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.08.2022.
//

import HookahTobaccoCore

extension TobaccoFilter {
    var isEmpty: Bool {
        manufacturer.isEmpty && tasteType.isEmpty && tastes.isEmpty
    }

    var isAllEmpty: Bool {
        manufacturer.isEmpty && tasteType.isEmpty && tastes.isEmpty && tobaccoType.isEmpty
    }
}
