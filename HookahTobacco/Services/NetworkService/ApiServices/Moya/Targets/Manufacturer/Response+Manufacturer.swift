//
//  Response+Manufacturer.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Foundation

struct TobaccosManufacturerResponse: Decodable {
    let tobaccos: [Tobacco]
}
