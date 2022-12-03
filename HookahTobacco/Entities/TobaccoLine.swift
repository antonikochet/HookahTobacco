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
    let tobaccoLeafType: [VarietyTobaccoLeaf]?
    let description: String
    let isBase: Bool
}

enum VarietyTobaccoLeaf: Int, CaseIterable {
    case burley = 0
    case virginia
    case oriental

    var name: String {
        switch self {
        case .burley:
            return "Берли"
        case .virginia:
            return "Вирджиния"
        case .oriental:
            return "Ориентал"
        }
    }

    var description: String {
        switch self {
        case .burley:
            return """
                Берли – лист для крепких смесей. Он нарезан мелко, ароматизатор впитывает быстро,\
                уровень жаростойкости низкий. Вариант для любителей кальяна с опытом.
                """
        case .virginia:
            return "Ориентал средней нарезки подходит, как для крепких, так и для легких смесей."
        case .oriental:
            return """
                Вирджиния – крупно нарезанный лист с необычным вкусом, используется для подготовки\
                табака путем сушки сырья дымом.
                """
        }
    }
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
