//
//  AdminApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation

final class AdminApiService: BaseApiService {

}

extension AdminApiService: AdminNetworkingServiceProtocol {
    func addData<T>(_ data: T, completion: CompletionResultBlock<T>?) where T: DataNetworkingServiceProtocol {
        if let manufacturer = data as? Manufacturer {
            sendRequest(object: Manufacturer.self,
                        target: Api.Manufacturer.create(ManufacturerRequest(manufacturer: manufacturer)),
                        completion: completion as? CompletionResultBlock)
        } else if let tobacco = data as? Tobacco {
            sendRequest(object: Tobacco.self,
                        target: Api.Tobacco.create(TobaccoRequest(tobacco: tobacco)),
                        completion: completion as? CompletionResultBlock)
        } else if let tobaccoLine = data as? TobaccoLine {
            sendRequest(object: TobaccoLine.self,
                        target: Api.TobaccoLines.create(tobaccoLine),
                        completion: completion as? CompletionResultBlock)
        } else if let taste = data as? Taste {
            sendRequest(object: Taste.self,
                        target: Api.Tastes.create(taste),
                        completion: completion as? CompletionResultBlock)
        } else if let tasteType = data as? TasteType {
            sendRequest(object: TasteType.self,
                        target: Api.TasteTypes.create(tasteType),
                        completion: completion as? CompletionResultBlock)
        } else if let country = data as? Country {
            sendRequest(object: Country.self,
                        target: Api.Countries.create(country),
                        completion: completion as? CompletionResultBlock)
        } else {
            fatalError("не реализовано добавоение в бд для типа \(type(of: data))")
        }
    }

    func setData<T>(_ data: T, completion: CompletionResultBlock<T>?) where T: DataNetworkingServiceProtocol {
        if let manufacturer = data as? Manufacturer {
            sendRequest(object: Manufacturer.self,
                        target: Api.Manufacturer.update(id: manufacturer.uid,
                                                        ManufacturerRequest(manufacturer: manufacturer)),
                        completion: completion as? CompletionResultBlock)
        } else if let tobacco = data as? Tobacco {
            sendRequest(object: Tobacco.self,
                        target: Api.Tobacco.update(id: tobacco.uid,
                                                   TobaccoRequest(tobacco: tobacco)),
                        completion: completion as? CompletionResultBlock)
        } else if let tobaccoLine = data as? TobaccoLine {
            sendRequest(object: TobaccoLine.self,
                        target: Api.TobaccoLines.update(id: tobaccoLine.uid, tobaccoLine),
                        completion: completion as? CompletionResultBlock)
        } else if let taste = data as? Taste {
            sendRequest(object: Taste.self,
                        target: Api.Tastes.update(id: taste.uid, taste),
                        completion: completion as? CompletionResultBlock)
        } else if let country = data as? Country {
            sendRequest(object: Country.self,
                        target: Api.Countries.update(id: country.uid, country),
                        completion: completion as? CompletionResultBlock)
        } else {
            fatalError("не реализовано изменение в бд для типа \(type(of: data))")
        }
    }

    func setDBVersion(_ newVersion: Int, completion: CompletionBlockWithParam<HTError?>?) {

    }

    func receiveAppeals(page: Int,
                        status: AppealStatus?,
                        themes: [ThemeAppeal],
                        completion: CompletionResultBlock<PageResponse<AppealResponse>>?) {
        let request = AppealFilterRequest(page: page, themes: themes, status: status)
        sendRequest(object: PageResponse<AppealResponse>.self,
                    target: Api.Appeals.list(request),
                    completion: completion as? CompletionResultBlock)
    }

    func updateAppeal(by id: Int, _ answer: String, completion: CompletionResultBlock<AppealResponse>?) {
        sendRequest(object: AppealResponse.self,
                    target: Api.Appeals.updateAppeal(id: id, answer: answer),
                    completion: completion as? CompletionResultBlock)
    }

    func handledAppeal(_ id: Int, completion: CompletionBlockWithParam<HTError?>?) {
        sendRequest(object: EmptyResponse.self,
                    target: Api.Appeals.handled(id: id)) { _ in
            completion?(nil)
        } failure: { error in
            completion?(error)
        }

    }

}
