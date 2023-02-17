//
//  ApiServices.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation

final class ApiServices {

    private let apiProvider: NetworkingProviderProtocol

    init(apiProvider: NetworkingProviderProtocol) {
        self.apiProvider = apiProvider
    }
}

extension ApiServices: GetDataNetworkingServiceProtocol {
    func receiveData<T>(type: T.Type,
                        completion: GetDataNetworkingServiceCompletion<[T]>?
    ) where T: DataNetworkingServiceProtocol {
        fatalError("receiveData")
    }

    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?) {
        let request = GetTobaccosManufacturerRequest(idManufacurer: manufacturer.uid)
        apiProvider.sendRequest(request) { response in
            switch response.result {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
        fatalError("getTobaccos")
    }

    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?) {
        fatalError("getDataBaseVersion")
    }
}
