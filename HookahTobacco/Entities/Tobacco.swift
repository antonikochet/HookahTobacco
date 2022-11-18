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
    var uid: String?
    let name: String
    let taste: [Int]
    let idManufacturer: String
    let nameManufacturer: String
    let description: String
    var image: Data?
//    let variety: VarietyTobaccoLeaf
    //грамовка
    //крепкость
    //тип вкуса
    //вкус переделать на структуру
    //серия (опционально)
    
}
