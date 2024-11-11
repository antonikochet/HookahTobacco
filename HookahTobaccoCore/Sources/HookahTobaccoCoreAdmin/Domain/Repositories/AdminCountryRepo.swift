//
//  AdminCountryRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork
import HookahTobaccoCore

public protocol AdminCountryRepoProtocol {
    func create(country: Country, completion: ResultBlock<Country>?)
    func update(country: Country, completion: ResultBlock<Country>?)
}

public final class AdminCountryRepo: BaseRepo, AdminCountryRepoProtocol {
    public func create(country: Country, completion: ResultBlock<Country>?) {
        let dto = CountryChangeDTO(id: country.id != -1 ? country.id : nil,
                                   name: country.name)
        let target = Api.Country.create(dto)
        sendRequest(object: CountryDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Country(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func update(country: Country, completion: ResultBlock<Country>?) {
        let dto = CountryChangeDTO(id: country.id,
                                   name: country.name)
        let target = Api.Country.update(id: country.id, dto)
        sendRequest(object: CountryDTO.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Country(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
