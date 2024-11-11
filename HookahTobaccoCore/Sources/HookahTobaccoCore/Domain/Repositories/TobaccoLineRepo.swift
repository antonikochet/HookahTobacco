//
//  TobaccoLineRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol TobaccoLineRepoProtocol {
    func fetchTobaccoLine(completion: ResultBlock<[TobaccoLine]>?)
}

public final class TobaccoLineRepo: BaseRepo, TobaccoLineRepoProtocol {
    public func fetchTobaccoLine(completion: ResultBlock<[TobaccoLine]>?) {
        sendRequest(object: [TobaccoLineDTO].self,
                    target: Api.Taste.list) { result in
            switch result {
            case .success(let dto):
                let result = dto.map { TobaccoLine(dto: $0) }
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
