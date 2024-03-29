//
//
//  AddManufacturerEntity.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

struct AddManufacturerEntity {
    struct EnterData {
        let name: String?
        let description: String?
        let link: String?
    }

    struct Manufacturer {
        let name: String
        let description: String?
        let link: String?
    }

    struct ViewModel {
        let name: String
        let description: String
        let textButton: String
        let link: String
        let isEnabledAddTobaccoLine: Bool
    }
}
