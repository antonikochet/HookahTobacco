//
//  FavoriteTobaccoRepo.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public protocol FavoriteTobaccoRepoProtocol {
    func fetch(page: Int, completion: ResultBlock<Page<Tobacco>>?)
    func fetch(page: Int) async throws -> Page<Tobacco>
    func update(tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?)
    func update(tobaccos: [Tobacco]) async throws -> [Tobacco]
}

public final class FavoriteTobaccoRepo: BaseRepo, FavoriteTobaccoRepoProtocol {
    public func fetch(page: Int, completion: ResultBlock<Page<Tobacco>>?) {
        let target = Api.FavoriteTobacco.getFavoritesTobacco(page: page)
        sendRequest(object: PageDTO<TobaccoDTO>.self, target: target) { result in
            switch result {
            case .success(let dto):
                let result = Page(count: dto.count,
                                  next: dto.next,
                                  previous: dto.previous,
                                  results: dto.results.map { Tobacco(dto: $0) })
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func fetch(page: Int) async throws -> Page<Tobacco> {
        let target = Api.FavoriteTobacco.getFavoritesTobacco(page: page)
        let dto = try await sendRequest(object: PageDTO<TobaccoDTO>.self, target: target)
        return Page(count: dto.count,
                    next: dto.next,
                    previous: dto.previous,
                    results: dto.results.map { Tobacco(dto: $0) })
    }
    
    public func update(tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?) {
        let target = Api.FavoriteTobacco.updateFavoriteTobaccos(tobaccos.map { .init(id: $0.id, flag: $0.isFavorite) })
        sendRequest(object: [TobaccoDTO].self, target: target) { result in
            switch result {
            case .success(let dto):
                let result = dto.map { Tobacco(dto: $0) }
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func update(tobaccos: [Tobacco]) async throws -> [Tobacco] {
        let target = Api.FavoriteTobacco.updateFavoriteTobaccos(tobaccos.map { .init(id: $0.id, flag: $0.isFavorite) })
        let dto = try await sendRequest(object: [TobaccoDTO].self, target: target)
        return dto.map { Tobacco(dto: $0) }
    }
}
