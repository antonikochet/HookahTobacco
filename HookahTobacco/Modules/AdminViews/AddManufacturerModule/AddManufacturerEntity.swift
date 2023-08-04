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

    struct TobaccoLine {
        let name: String
        let packetingFormats: [Int]
        let selectedTobaccoTypeIndex: Int
        let description: String
        let isBase: Bool
        let selectedTobaccoLeafTypeIndexs: [Int]
    }

    struct ViewModel {
        let name: String
        let description: String
        let textButton: String
        let link: String
        let isEnabledAddTobaccoLine: Bool
    }

    struct TobaccoLineModel: AddTobaccoLineViewViewModelProtocol {
        var name: String?
        var paramTobacco: AddParamTobaccoViewModelProtocol
        var description: String?
    }

    struct ParamTobaccoModel: AddParamTobaccoViewModelProtocol {
        var packetingFormats: String
        var tobaccoTypes: [String]
        var selectedTobaccoTypeIndex: Int
        var isBaseLine: Bool
        var tobaccoLeafTypes: [String]
        var selectedTobaccoLeafTypeIndex: [Int]
    }
}
