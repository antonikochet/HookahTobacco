//
//  TobaccoLine.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.11.2022.
//

import HookahTobaccoCore

extension VarietyTobaccoLeaf: CaseIterable {
    public static var allCases: [VarietyTobaccoLeaf] = [.burley, .oriental, .virginia]
    
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

extension TobaccoType: CaseIterable {
    public static var allCases: [TobaccoType] = [.tobacco, .nonTobaccoBlend]
    
    var name: String {
        switch self {
        case .tobacco:
            return "Табак"
        case .nonTobaccoBlend:
            return "Беcтабачная смесь"
        }
    }
}
