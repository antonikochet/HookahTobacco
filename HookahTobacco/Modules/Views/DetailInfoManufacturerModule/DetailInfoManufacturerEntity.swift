//
//
//  DetailInfoManufacturerEntity.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import Foundation

struct DetailInfoManufacturerEntity {
    struct CellViewModel: DetailInfoManufacturerCellViewModelProtocol {
        var country: String
        var description: String
        var iconImage: Data?
    }
}


