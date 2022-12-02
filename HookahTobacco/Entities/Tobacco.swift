//
//  Tobacco.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.08.2022.
//

import Foundation

struct Tobacco {
    var id: String = ""
    var uid: String = ""
    let name: String
    let tastes: [Taste]
    let idManufacturer: String
    let nameManufacturer: String
    let description: String
    let line: TobaccoLine
    var image: Data?
}
