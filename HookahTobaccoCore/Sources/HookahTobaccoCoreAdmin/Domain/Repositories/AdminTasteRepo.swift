//
//  AdminTasteRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork
import HookahTobaccoCore

public protocol AdminTasteRepoProtocol {
    func create(taste: Taste, completion: ResultBlock<Taste>?)
    func update(taste: Taste, completion: ResultBlock<Taste>?)
}

public final class AdminTasteRepo: BaseRepo, AdminTasteRepoProtocol {
    public func create(taste: Taste, completion: ResultBlock<Taste>?) {
        let dto = TasteChangeDTO(id: taste.id != -1 ? taste.id : nil,
                                 taste: taste.taste,
                                 typeTaste: taste.typeTaste.map { $0.id })
        let target = Api.Taste.create(dto)
        sendRequest(object: TasteDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Taste(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func update(taste: Taste, completion: ResultBlock<Taste>?) {
        let dto = TasteChangeDTO(id: taste.id,
                                 taste: taste.taste,
                                 typeTaste: taste.typeTaste.map { $0.id })
        let target = Api.Taste.update(id: taste.id, dto)
        sendRequest(object: TasteDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Taste(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
