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
        let country: String?
        let description: String?
        let link: String?
    }

    struct Manufacturer {
        let name: String
        let country: String
        let description: String?
        let link: String?
    }

    struct TobaccoLine {
        let name: String
        let packetingFormats: [Int]
        let selectedTobaccoTypeIndex: Int
        let description: String
        let isBase: Bool
    }

    struct ViewModel {
        let name: String
        let country: String
        let description: String
        let textButton: String
        let link: String
    }

    struct TobaccoLineModel: AddTobaccoLineViewViewModelProtocol {
        var name: String?
        var packetingFormats: String?
        var tobaccoTypes: [String]
        var selectedTobaccoTypeIndex: Int
        var description: String?
        var isBase: Bool
    }
}
