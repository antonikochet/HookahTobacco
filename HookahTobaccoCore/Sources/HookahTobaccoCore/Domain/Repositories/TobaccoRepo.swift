//
//  TobaccoRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol TobaccoRepoProtocol {
    func fetchTobacco(page: Int, search: String?, filter: TobaccoFilter?, completion: ResultBlock<Page<Tobacco>>?)
    func fetchTobaccoFilters(completion: ResultBlock<TobaccoFilter>?)
    func updateTobaccoFilters(filters: TobaccoFilter, completion: ResultBlock<TobaccoFilter>?)
}

public final class TobaccoRepo: BaseRepo, TobaccoRepoProtocol {
    public func fetchTobacco(page: Int, search: String?, filter: TobaccoFilter?, completion: ResultBlock<Page<Tobacco>>?) {
        let filterDTO = TobaccoFilterRequestDTO(filter: filter)
        let target = Api.Tobacco.list(page: page, search: search, filter: filterDTO)
        sendRequest(object: PageDTO<TobaccoDTO>.self, target: target) { result in
            switch result {
            case .success(let dto):
                let result = Page(
                    count: dto.count,
                    next: dto.next,
                    previous: dto.previous,
                    results: dto.results.map { Tobacco(dto: $0) })
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func fetchTobaccoFilters(completion: ResultBlock<TobaccoFilter>?) {
        sendRequest(object: TobaccoFilterDTO.self,
                    target: Api.Tobacco.getFilter) { result in
            switch result {
            case .success(let dto):
                let result = TobaccoFilter(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func updateTobaccoFilters(filters: TobaccoFilter, completion: ResultBlock<TobaccoFilter>?) {
        guard let dto = TobaccoFilterRequestDTO(filter: filters) else { return }
        sendRequest(object: TobaccoFilterDTO.self,
                    target: Api.Tobacco.updateFilter(dto)) { result in
            switch result {
            case .success(let dto):
                let result = TobaccoFilter(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
