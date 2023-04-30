//
//  ApiServices.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation

final class ApiServices {

    private let apiProvider: NetworkingProviderProtocol
    private let handlerErrors: NetworkHandlerErrors

    init(apiProvider: NetworkingProviderProtocol,
         handlerErrors: NetworkHandlerErrors) {
        self.apiProvider = apiProvider
        self.handlerErrors = handlerErrors
    }

    private func handleApiError(_ data: Data?, error: Error) -> ApiError? {
        guard let data,
              var apiError = try? JSONDecoder().decode(ApiError.self, from: data),
              let afError = error.asAFError else { return nil }
        apiError.codeError = afError.responseCode
        apiError.url = afError.url?.absoluteString
        return apiError
    }
}

// MARK: - private methods for get requests

private extension ApiServices {
    func receiveData<T>(
        for request: T,
        completion: GetDataNetworkingServiceCompletion<T.Response>?
    ) where T: ApiRequest {
        apiProvider.sendRequest(request) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let data):
                completion?(.success(data))
            case .failure(let error):
                let apiError = handleApiError(response.data, error: error)
                completion?(.failure(self.handlerErrors.handlerError(apiError ?? error)))
            }
        }
    }
}

// MARK: - GetDataNetworkingServiceProtocol
extension ApiServices: GetDataNetworkingServiceProtocol {
    func receiveData<T>(type: T.Type,
                        completion: GetDataNetworkingServiceCompletion<[T]>?
    ) where T: DataNetworkingServiceProtocol {
        switch type {
        case is Manufacturer.Type:
            receiveData(for: GetManufacturerRequest(),
                        completion: completion as? GetDataNetworkingServiceCompletion<[Manufacturer]>)
        case is Tobacco.Type:
            receiveData(for: GetTobaccoRequest(),
                        completion: completion as? GetDataNetworkingServiceCompletion<[Tobacco]>)
        case is Taste.Type:
            receiveData(for: GetTasteRequest(),
                        completion: completion as? GetDataNetworkingServiceCompletion<[Taste]>)
        case is TobaccoLine.Type:
            receiveData(for: GetTobaccoLineRequest(),
                        completion: completion as? GetDataNetworkingServiceCompletion<[TobaccoLine]>)
        case is TasteType.Type:
            receiveData(for: GetTasteTypeRequest(),
                        completion: completion as? GetDataNetworkingServiceCompletion<[TasteType]>)
        case is Country.Type:
            receiveData(for: GetCountryRequest(),
                        completion: completion as? GetDataNetworkingServiceCompletion<[Country]>)
        default: break
        }
    }

    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?) {
        let request = GetTobaccosManufacturerRequest(idManufacurer: manufacturer.uid)
        apiProvider.sendRequest(request) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let tobaccoResponse):
                completion?(.success(tobaccoResponse.tobaccos))
            case .failure(let error):
                let apiError = self.handleApiError(response.data, error: error)
                completion?(.failure(self.handlerErrors.handlerError(apiError ?? error)))
            }
        }
    }

    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?) {
        fatalError("no implementation\(#function)")
    }
}

// MARK: - GetImageNetworkingServiceProtocol
extension ApiServices: GetImageNetworkingServiceProtocol {
    func getImage(for type: ImageNetworkingDataProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        fatalError("no implementation\(#function)")
    }
}

// MARK: - SetDataNetworkingServiceProtocol
extension ApiServices: SetDataNetworkingServiceProtocol {
    func addData<T>(_ data: T, completion: AddDataNetworkingCompletion?) where T : DataNetworkingServiceProtocol {
        fatalError("no implementation\(#function)")
    }
    
    func setData<T>(_ data: T, completion: SetDataNetworingCompletion?) where T : DataNetworkingServiceProtocol {
        fatalError("no implementation\(#function)")
    }
    
    func setDBVersion(_ newVersion: Int, completion: SetDataNetworingCompletion?) {
        fatalError("no implementation\(#function)")
    }
    
    
}

// MARK: - SetImageNetworkingServiceProtocol
extension ApiServices: SetImageNetworkingServiceProtocol {
    func addImage(by fileURL: URL, for image: ImageNetworkingDataProtocol, completion: @escaping Completion) {
        fatalError("no implementation\(#function)")
    }
    
    func setImage(from oldImage: ImageNetworkingDataProtocol, to newURL: URL, for newImage: ImageNetworkingDataProtocol, completion: @escaping Completion) {
        fatalError("no implementation\(#function)")
    }
    
    func setImageName(from oldImage: ImageNetworkingDataProtocol, to newImage: ImageNetworkingDataProtocol, completion: @escaping Completion) {
        fatalError("no implementation\(#function)")
    }
    
    
}
