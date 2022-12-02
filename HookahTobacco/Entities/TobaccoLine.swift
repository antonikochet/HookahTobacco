//
//  TobaccoLine.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.11.2022.
//

import Foundation

struct TobaccoLine {
    var id: String = ""
    var uid: String = ""
    let name: String
    let packetingFormat: [Int]
    let tobaccoType: TobaccoType
    let description: String
    let isBase: Bool
}

enum TobaccoType: Int, CaseIterable {
    case tobacco = 0
    case nonTobaccoBlend

    var name: String {
        switch self {
        case .tobacco:
            return "Табак"
        case .nonTobaccoBlend:
            return "Беcтабачная смесь"
        }
    }
}
