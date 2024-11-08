//
//  AdminTobaccoLineRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork
import HookahTobaccoCore

public protocol AdminTobaccoLineRepoProtocol {
    func create(tobaccoLine: TobaccoLine, completion: ResultBlock<TobaccoLine>?)
    func update(tobaccoLine: TobaccoLine, completion: ResultBlock<TobaccoLine>?)
}

public final class AdminTobaccoLineRepo: BaseRepo, AdminTobaccoLineRepoProtocol {
    public func create(tobaccoLine: TobaccoLine, completion: ResultBlock<TobaccoLine>?) {
        let dto = TobaccoLineChangeDTO(
            id: tobaccoLine.id != -1 ? tobaccoLine.id : nil,
            name: tobaccoLine.name,
            packeting_format: tobaccoLine.packetingFormat.map { String($0) }.joined(separator: ","),
            tobacco_type: tobaccoLine.tobaccoType.rawValue,
            tobacco_leaf_type: tobaccoLine.tobaccoLeafType?.map { $0.rawValue } ?? [],
            description: tobaccoLine.description,
            is_base: tobaccoLine.isBase,
            manufacturer: tobaccoLine.manufacturerId
        )
        let target = Api.TobaccoLine.create(dto)
        sendRequest(object: TobaccoLineDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = TobaccoLine(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func update(tobaccoLine: TobaccoLine, completion: ResultBlock<TobaccoLine>?) {
        let dto = TobaccoLineChangeDTO(
            id: tobaccoLine.id,
            name: tobaccoLine.name,
            packeting_format: tobaccoLine.packetingFormat.map { String($0) }.joined(separator: ","),
            tobacco_type: tobaccoLine.tobaccoType.rawValue,
            tobacco_leaf_type: tobaccoLine.tobaccoLeafType?.map { $0.rawValue } ?? [],
            description: tobaccoLine.description,
            is_base: tobaccoLine.isBase,
            manufacturer: tobaccoLine.manufacturerId
        )
        let target = Api.TobaccoLine.update(id: tobaccoLine.id, dto)
        sendRequest(object: TobaccoLineDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = TobaccoLine(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
