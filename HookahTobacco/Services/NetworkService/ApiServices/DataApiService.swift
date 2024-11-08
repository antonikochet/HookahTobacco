//
//  DataApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation
import HookahTobaccoCore

final class DataApiService: BaseApiService {

}

extension DataApiService: GetDataNetworkingServiceProtocol {
    func receiveTobacco(page: Int,
                        search: String?,
                        filters: TobaccoFilters?,
                        completion: ResultBlock<PageResponse<Tobacco>>?) {
        sendRequest(object: PageResponse<Tobacco>.self,
                    target: Api.Tobacco.list(page: page, search: search, filter: TobaccoFilterRequest(filters)),
                    completion: completion as? ResultBlock)
    }

    func receiveTobaccoFilters(completion: ResultBlock<TobaccoFilters>?) {
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

    func updateTobaccoFilters(filters: TobaccoFilters, completion: ResultBlock<TobaccoFilters>?) {
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

    func receiveImage(for url: String, completion: ResultBlock<Data>?) {
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

    func receiveTobaccos(
        for manufacturer: Manufacturer,
        completion: ResultBlock<[Tobacco]>?
    ) {
//        let target = Api.Manufacturer.tobaccos(id: manufacturer.id)
//        sendRequest(object: TobaccosManufacturerResponse.self, target: target) { result in
//            completion?(.success(result.tobaccos))
//        } failure: { error in
//            completion?(.failure(error))
//        }
    }
}
