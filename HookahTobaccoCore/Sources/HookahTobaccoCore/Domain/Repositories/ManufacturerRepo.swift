//
//  ManufacturerRepo.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol ManufacturerRepoProtocol {
    func fetchManufacturer(completion: ResultBlock<[Manufacturer]>?)
}

public final class ManufacturerRepo: BaseRepo, ManufacturerRepoProtocol {
    public func fetchManufacturer(completion: ResultBlock<[Manufacturer]>?) {
        sendRequest(object: [ManufacturerDTO].self,
                    target: Api.Manufacturer.list) { result in
            switch result {
            case .success(let dto):
                let result = dto.map { Manufacturer(dto: $0) }
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
