//
//  AdminAppealsRepo.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

import HookahTobaccoNetwork
import HookahTobaccoCore

public protocol AdminAppealsRepoProtocol {
    func fetchAppeals(page: Int,
                      status: AppealStatus?,
                      themes: [ThemeAppeal],
                      completion: ResultBlock<Page<AppealEntity>>?)
    func updateAppeal(by id: Int, _ answer: String, completion: ResultBlock<AppealEntity>?)
    func handledAppeal(_ id: Int, completion: BlockWithParam<DomainError?>?)
}

public final class AdminAppealsRepo: BaseRepo, AdminAppealsRepoProtocol {
    public func fetchAppeals(page: Int,
                      status: AppealStatus?,
                      themes: [ThemeAppeal],
                      completion: ResultBlock<Page<AppealEntity>>?) {
        let request = AppealFilterRequestDTO(page: page,
                                             themeIds: themes.map { $0.id },
                                             status: status?.stringRawValue)
        let target = Api.Appeals.list(request)
        sendRequest(object: PageDTO<AppealDTO>.self,
                    target: target) { result in
            switch result {
            case .success(let dto):
                let result = Page(
                    count: dto.count,
                    next: dto.next,
                    previous: dto.previous,
                    results: dto.results.map { AppealEntity(dto: $0) })
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func updateAppeal(by id: Int, _ answer: String, completion: ResultBlock<AppealEntity>?) {
        sendRequest(object: AppealDTO.self,
                    target: Api.Appeals.updateAppeal(id: id, answer: answer)) { result in
            switch result {
            case .success(let dto):
                let result = AppealEntity(dto: dto)
                completion?(.success(result))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func handledAppeal(_ id: Int, completion: BlockWithParam<DomainError?>?) {
        sendRequest(object: EmptyDTO.self,
                    target: Api.Appeals.handled(id: id)) { _ in
            completion?(nil)
        } failure: { error in
            completion?(error)
        }
    }
}
