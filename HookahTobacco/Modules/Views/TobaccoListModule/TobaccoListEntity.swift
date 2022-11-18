//
//
//  TobaccoListEntity.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation

struct TobaccoListEntity {
    struct Tobacco {
        let name: String
        let nameManufacturer: String
        let tasty: [Taste]
        let image: Data?
    }
}
