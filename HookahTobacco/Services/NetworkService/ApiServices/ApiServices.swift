//
//  ApiServices.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation
import Moya
import Alamofire

final class ApiServices {

    private let provider: MoyaProvider<MultiTarget>
    private let handlerErrors: NetworkHandlerErrors

    init(provider: MoyaProvider<MultiTarget>,
         handlerErrors: NetworkHandlerErrors) {
        self.provider = provider
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

    private func showError(_ line: String) {
        #if DEBUG
        print("‼️‼️‼️\n\(line)\n‼️‼️‼️")
        #endif
    }
}

// MARK: - private methods for get requests

private extension ApiServices {
    func sendRequest<T: Decodable>(
        object: T.Type,
        target: TargetType,
        completion: GetDataNetworkingServiceCompletion<T>?
    ) {
        provider.request(object: object, target: MultiTarget(target)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                do {
                    let data = try response.map(T.self)
                    completion?(.success(data))
                } catch {
                    self.showError("\(error)")
                    let networkingError = self.handlerErrors.handlerError(error)
                    completion?(.failure(networkingError))
                }
            case let .failure(error):
                self.showError("\(error)")
                let networkingError = self.handlerErrors.handlerError(error)
                completion?(.failure(networkingError))
            }
        }
    }

    func getImage(_ url: String, completion: ((Result<Data?, NetworkError>) -> Void)?) {
        AF.request(url).response { [weak self] response in
            guard let self else { return }
            switch response.result {
            case let .success(data):
                completion?(.success(data))
            case let .failure(error):
                self.showError("\(error)")
                let apiError = self.handlerErrors.handlerError(error)
                completion?(.failure(apiError))
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
            sendRequest(object: [Manufacturer].self,
                        target: Api.Manufacturer.list,
                        completion: completion as? GetDataNetworkingServiceCompletion<[Manufacturer]>)
        case is Tobacco.Type:
            sendRequest(object: [Tobacco].self,
                        target: Api.Tobacco.list,
                        completion: completion as? GetDataNetworkingServiceCompletion<[Tobacco]>)
        case is Taste.Type:
            sendRequest(object: [Taste].self,
                        target: Api.Tastes.list,
                        completion: completion as? GetDataNetworkingServiceCompletion<[Taste]>)
        case is TobaccoLine.Type:
            sendRequest(object: [TobaccoLine].self,
                        target: Api.TobaccoLines.list,
                        completion: completion as? GetDataNetworkingServiceCompletion<[TobaccoLine]>)
        case is TasteType.Type:
            sendRequest(object: [TasteType].self,
                        target: Api.TasteTypes.list,
                        completion: completion as? GetDataNetworkingServiceCompletion<[TasteType]>)
        case is Country.Type:
            sendRequest(object: [Country].self,
                        target: Api.Country.list,
                        completion: completion as? GetDataNetworkingServiceCompletion<[Country]>)
        default: break
        }
    }

    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?) {
        let target = Api.Manufacturer.tobaccos(id: manufacturer.uid)
        sendRequest(object: TobaccosManufacturerResponse.self, target: target) { result in
            switch result {
            case let .success(data):
                completion?(.success(data.tobaccos))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }

    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?) {
        completion?(.success(1))
    }
}

// MARK: - GetImageNetworkingServiceProtocol
extension ApiServices: GetImageNetworkingServiceProtocol {
    func getImage(for url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        getImage(url) { result in
            switch result {
            case let .success(data):
                if let data {
                    completion(.success(data))
                } else {
                    completion(.failure(.unknownDataError("photo on \(url)")))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - SetDataNetworkingServiceProtocol

extension ApiServices: SetDataNetworkingServiceProtocol {
    func addData<T>(_ data: T, completion: DataNetworkingCompletion<T>?) where T: DataNetworkingServiceProtocol {
        if let manufacturer = data as? Manufacturer {
            sendRequest(object: Manufacturer.self,
                        target: Api.Manufacturer.create(ManufacturerRequest(manufacturer: manufacturer)),
                        completion: completion as? DataNetworkingCompletion)
        } else if let tobacco = data as? Tobacco {
            sendRequest(object: Tobacco.self,
                        target: Api.Tobacco.create(TobaccoRequest(tobacco: tobacco)),
                        completion: completion as? DataNetworkingCompletion)
        } else if let tobaccoLine = data as? TobaccoLine {
            sendRequest(object: TobaccoLine.self,
                        target: Api.TobaccoLines.create(tobaccoLine),
                        completion: completion as? DataNetworkingCompletion)
        } else if let taste = data as? Taste {
            sendRequest(object: Taste.self,
                        target: Api.Tastes.create(taste),
                        completion: completion as? DataNetworkingCompletion)
        } else if let tasteType = data as? TasteType {
            sendRequest(object: TasteType.self,
                        target: Api.TasteTypes.create(tasteType),
                        completion: completion as? DataNetworkingCompletion)
        } else {
            fatalError("не реализовано добавоение в бд для типа \(type(of: data))")
        }
    }

    func setData<T>(_ data: T, completion: DataNetworkingCompletion<T>?) where T: DataNetworkingServiceProtocol {
        if let manufacturer = data as? Manufacturer {
            sendRequest(object: Manufacturer.self,
                        target: Api.Manufacturer.update(id: manufacturer.uid,
                                                        ManufacturerRequest(manufacturer: manufacturer)),
                        completion: completion as? DataNetworkingCompletion)
        } else if let tobacco = data as? Tobacco {
            sendRequest(object: Tobacco.self,
                        target: Api.Tobacco.update(id: tobacco.uid,
                                                   TobaccoRequest(tobacco: tobacco)),
                        completion: completion as? DataNetworkingCompletion)
        } else if let tobaccoLine = data as? TobaccoLine {
            sendRequest(object: TobaccoLine.self,
                        target: Api.TobaccoLines.update(id: tobaccoLine.uid, tobaccoLine),
                        completion: completion as? DataNetworkingCompletion)
        } else if let taste = data as? Taste {
            sendRequest(object: Taste.self,
                        target: Api.Tastes.update(id: taste.uid, taste),
                        completion: completion as? DataNetworkingCompletion)
        } else {
            fatalError("не реализовано изменение в бд для типа \(type(of: data))")
        }
    }

    func setDBVersion(_ newVersion: Int, completion: SetDataNetworingCompletion?) {
        fatalError("no implementation\(#function)")
    }
}
