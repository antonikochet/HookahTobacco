//
//  ManufacturerRepo.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol ManufacturerRepoProtocol {
    func fetchManufacturer(completion: ResultBlock<[Manufacturer]>?)
    func fetchManufacturer() async throws -> [Manufacturer]
    func fetchTobaccos(for manufacturer: Manufacturer) async throws -> [Tobacco]
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
    
    public func fetchManufacturer() async throws -> [Manufacturer] {
        let dto = try await sendRequest(
            object: [ManufacturerDTO].self,
            target: Api.Manufacturer.list
        )
        return dto.map { Manufacturer(dto: $0) }
    }
    
    public func fetchTobaccos(for manufacturer: Manufacturer) async throws -> [Tobacco] {
        let target = Api.Manufacturer.tobaccos(id: manufacturer.id)
        let dto = try await sendRequest(object: ManufacturerTobaccosDTO.self, target: target)
        return dto.tobaccos.map { Tobacco(dto: $0) }
    }
}
