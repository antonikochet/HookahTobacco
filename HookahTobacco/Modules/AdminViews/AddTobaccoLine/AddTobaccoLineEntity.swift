//
//
//  AddTobaccoLineEntity.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.08.2023.
//
//

import Foundation

struct AddTobaccoLineEntity {
    struct ViewModel {
        var name: String
        var packetingFormats: String
        var selectedTobaccoTypeIndex: Int
        var description: String
        var isBase: Bool
        var selectedTobaccoLeafTypeIndexs: [Int]
    }

    struct TobaccoLine {
        let name: String
        let packetingFormats: [Int]
        let selectedTobaccoTypeIndex: Int
        let description: String
        let isBase: Bool
        let selectedTobaccoLeafTypeIndexs: [Int]
    }

    struct EnterData {
        var name: String?
        var packetingFormats: String
        var tobaccoTypes: [String]
        var selectedTobaccoTypeIndex: Int
        var isBaseLine: Bool
        var tobaccoLeafTypes: [String]
        var selectedTobaccoLeafTypeIndex: [Int]
        var description: String?
    }
}
