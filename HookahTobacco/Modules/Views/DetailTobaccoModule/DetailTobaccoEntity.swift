//
//
//  DetailTobaccoEntity.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import Foundation

struct DetailTobaccoEntity {
    struct Tobacco {
        let name: String
        let image: Data?
        let tastes: [Taste]
        let nameManufacturer: String
        let line: TobaccoLine
        let description: String
    }

    struct ViewModel {
        let image: Data?
        let name: String
        let nameManufacturer: String
        let description: String?
        let nameLine: String?
        let packetingFormat: String
        let tobaccoType: String
        let tobaccoLeafType: String?
    }
}
