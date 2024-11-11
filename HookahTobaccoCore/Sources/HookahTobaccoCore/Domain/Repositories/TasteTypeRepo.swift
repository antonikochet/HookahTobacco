//
//  TasteTypeRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol TasteTypeRepoProtocol {
    func fetchTasteType(completion: ResultBlock<[TasteType]>?)
}

public final class TasteTypeRepo: BaseRepo, TasteTypeRepoProtocol {
    public func fetchTasteType(completion: ResultBlock<[TasteType]>?) {
        sendRequest(object: [TasteTypeDTO].self,
                    target: Api.TasteType.list) { result in
            switch result {
            case .success(let dto):
                let result = dto.map { TasteType(dto: $0) }
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
