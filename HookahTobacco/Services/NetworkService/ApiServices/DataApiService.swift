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
        case is Tobacco.Type:
            sendRequest(object: [Tobacco].self,
                        target: Api.Tobacco.list,
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

    func getImage(for url: String, completion: CompletionResultBlock<Data>?) {
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

    func getTobaccos(
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
