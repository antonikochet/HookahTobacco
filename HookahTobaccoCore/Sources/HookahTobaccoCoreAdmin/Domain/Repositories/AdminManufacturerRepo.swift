//
//  AdminManufacturerRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation
import HookahTobaccoNetwork
import HookahTobaccoCore

public protocol AdminManufacturerRepoProtocol {
    func create(manufacturer: Manufacturer, completion: ResultBlock<Manufacturer>?)
    func update(manufacturer: Manufacturer, completion: ResultBlock<Manufacturer>?)
}

public final class AdminManufacturerRepo: BaseRepo, AdminManufacturerRepoProtocol {
    public func create(manufacturer: Manufacturer, completion: ResultBlock<Manufacturer>?) {
        let dto = ManufacturerRequestDTO(
            id: manufacturer.id != -1 ? manufacturer.id : nil,
            name: manufacturer.name,
            country_id: manufacturer.country.id,
            description: manufacturer.description,
            image_url: URL(string: manufacturer.urlImage),
            link: manufacturer.link,
            tobacco_lines: manufacturer.lines.map { $0.id }
        )
        let target = Api.Manufacturer.create(dto)
        sendRequest(object: ManufacturerDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Manufacturer(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func update(manufacturer: Manufacturer, completion: ResultBlock<Manufacturer>?) {
        let dto = ManufacturerRequestDTO(
            id: manufacturer.id,
            name: manufacturer.name,
            country_id: manufacturer.country.id,
            description: manufacturer.description,
            image_url: URL(string: manufacturer.urlImage),
            link: manufacturer.link,
            tobacco_lines: manufacturer.lines.map { $0.id }
        )
        let target = Api.Manufacturer.update(id: manufacturer.id, dto)
        sendRequest(object: ManufacturerDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Manufacturer(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
