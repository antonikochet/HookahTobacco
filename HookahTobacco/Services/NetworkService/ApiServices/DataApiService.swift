//
//  DataApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation

final class DataApiService: BaseApiService {

}

extension DataApiService: GetDataNetworkingServiceProtocol {
    func receiveData<T: DataNetworkingServiceProtocol>(
        type: T.Type,
        completion: CompletionResultBlock<[T]>?
    ) {
        switch type {
        case is Manufacturer.Type:
            sendRequest(object: [Manufacturer].self,
                        target: Api.Manufacturer.list,
                        completion: completion as? CompletionResultBlock)
        case is Taste.Type:
            sendRequest(object: [Taste].self,
                        target: Api.Tastes.list,
                        completion: completion as? CompletionResultBlock)
        case is TobaccoLine.Type:
            sendRequest(object: [TobaccoLine].self,
                        target: Api.TobaccoLines.list,
                        completion: completion as? CompletionResultBlock)
        case is TasteType.Type:
            sendRequest(object: [TasteType].self,
                        target: Api.TasteTypes.list,
                        completion: completion as? CompletionResultBlock)
        case is Country.Type:
            sendRequest(object: [Country].self,
                        target: Api.Countries.list,
                        completion: completion as? CompletionResultBlock)
        default:
            fatalError("Метод receiveData протокола GetDataNetworkingServiceProtocol" +
                       " не поддерживает для получения тип \(type)")
        }
    }

    func receiveTobacco(page: Int,
                        search: String?,
                        filters: TobaccoFilters?,
                        completion: CompletionResultBlock<PageResponse<Tobacco>>?) {
        sendRequest(object: PageResponse<Tobacco>.self,
                    target: Api.Tobacco.list(page: page, search: search, filter: TobaccoFilterRequest(filters)),
                    completion: completion as? CompletionResultBlock)
    }

    func receiveTobaccoFilters(completion: CompletionResultBlock<TobaccoFilters>?) {
        sendRequest(object: TobaccoFilterResponse.self,
                    target: Api.Tobacco.getFilter) { result in
            switch result {
            case .success(let response):
                completion?(.success(TobaccoFilters(response)))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func updateTobaccoFilters(filters: TobaccoFilters, completion: CompletionResultBlock<TobaccoFilters>?) {
        guard let request = TobaccoFilterRequest(filters) else { return }
        sendRequest(object: TobaccoFilterResponse.self,
                    target: Api.Tobacco.updateFilter(request)) { result in
            switch result {
            case .success(let response):
                completion?(.success(TobaccoFilters(response)))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func receiveImage(for url: String, completion: CompletionResultBlock<Data>?) {
        receiveImage(url) { result in
            switch result {
            case let .success(data):
                if let data {
                    completion?(.success(data))
                } else {
                    completion?(.failure(.unexpectedError))
                }
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }

    func receiveDetailData<T: DataNetworkingServiceProtocol>(
        type: T.Type,
        uid: Int,
        completion: CompletionResultBlock<T>?
    ) {
        switch type {
        case is Manufacturer.Type:
            sendRequest(object: Manufacturer.self,
                        target: Api.Manufacturer.detail(id: uid),
                        completion: completion as? CompletionResultBlock)
        default:
            fatalError("Метод receiveData протокола GetDataNetworkingServiceProtocol" +
                       " не поддерживает для получения тип \(type)")
        }
    }

    func receiveTobaccos(
        for manufacturer: Manufacturer,
        completion: CompletionResultBlock<[Tobacco]>?
    ) {
        let target = Api.Manufacturer.tobaccos(id: manufacturer.uid)
        sendRequest(object: TobaccosManufacturerResponse.self, target: target) { result in
            completion?(.success(result.tobaccos))
        } failure: { error in
            completion?(.failure(error))
        }
    }

    func getDataBaseVersion(completion: CompletionResultBlock<Int>?) {

    }
}
