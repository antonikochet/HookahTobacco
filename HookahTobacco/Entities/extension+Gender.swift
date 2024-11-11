//
//  extension+Gender.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoCore

extension Gender: CaseIterable {
    public static var allCases: [Gender] = [.notPicked, .male, .female]
    
    var name: String {
        switch self {
        case .notPicked:
            return "Не выбрано"
        case .male:
            return "Мужской"
        case .female:
            return "Женский"
        }
    }
}
