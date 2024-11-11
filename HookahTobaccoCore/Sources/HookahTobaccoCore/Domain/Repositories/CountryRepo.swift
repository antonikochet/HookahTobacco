//
//  CountryRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol CountryRepoProtocol {
    func fetchCountry(completion: ResultBlock<[Country]>?)
}

public final class CountryRepo: BaseRepo, CountryRepoProtocol {
    public func fetchCountry(completion: ResultBlock<[Country]>?) {
        sendRequest(object: [CountryDTO].self,
                    target: Api.Country.list) { result in
            switch result {
            case .success(let dto):
                let result = dto.map { Country(dto: $0) }
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
