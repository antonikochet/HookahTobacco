//
//  AdminTasteTypeRepo.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork
import HookahTobaccoCore

public protocol AdminTasteTypeRepoProtocol {
    func create(tasteType: TasteType, completion: ResultBlock<TasteType>?)
    func update(tasteType: TasteType, completion: ResultBlock<TasteType>?)
}

public final class AdminTasteTypeRepo: BaseRepo, AdminTasteTypeRepoProtocol {
    public func create(tasteType: TasteType, completion: ResultBlock<TasteType>?) {
        let dto = TasteTypeChangeDTO(id: tasteType.id != -1 ? tasteType.id : nil,
                                     name: tasteType.name)
        let target = Api.TasteType.create(dto)
        sendRequest(object: TasteTypeDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = TasteType(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func update(tasteType: TasteType, completion: ResultBlock<TasteType>?) {
        let dto = TasteTypeChangeDTO(id: tasteType.id,
                                     name: tasteType.name)
        let target = Api.TasteType.update(id: tasteType.id, dto)
        sendRequest(object: TasteTypeDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = TasteType(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
