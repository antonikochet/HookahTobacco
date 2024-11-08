//
//  TasteRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol TasteRepoProtocol {
    func fetchTaste(completion: ResultBlock<[Taste]>?)
}

public final class TasteRepo: BaseRepo, TasteRepoProtocol {
    public func fetchTaste(completion: ResultBlock<[Taste]>?) {
        sendRequest(object: [TasteDTO].self,
                    target: Api.Taste.list) { result in
            switch result {
            case .success(let dto):
                let result = dto.map { Taste(dto: $0) }
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
