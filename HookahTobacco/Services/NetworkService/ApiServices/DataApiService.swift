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
}
