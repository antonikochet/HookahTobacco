//
//  Tobacco.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.08.2022.
//

import Foundation

enum VarietyTobaccoLeaf: String {
    case burley = "Берли"
    case virginia = "Вирджиния"
    case tea = "Чайный"
}

struct Tobacco {
    let uid: String?
    let name: String
    let taste: [String]
    let idManufacturer: String
    let description: String
//    let variety: VarietyTobaccoLeaf
    //грамовка
    //крепкость
    //тип вкуса
    //вкус переделать на структуру
    //серия (опционально)
    
}
