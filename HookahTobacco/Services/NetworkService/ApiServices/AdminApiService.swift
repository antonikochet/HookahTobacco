//
//  AdminApiService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation
import HookahTobaccoCore

final class AdminApiService: BaseApiService {

}

extension AdminApiService: AdminNetworkingServiceProtocol {
    func addData<T>(_ data: T, completion: ResultBlock<T>?) where T: DataNetworkingServiceProtocol {
        if let manufacturer = data as? Manufacturer {
            sendRequest(object: Manufacturer.self,
                        target: Api.Manufacturer.create(ManufacturerRequest(manufacturer: manufacturer)),
                        completion: completion as? ResultBlock)
        } else if let tobacco = data as? Tobacco {
            sendRequest(object: Tobacco.self,
                        target: Api.Tobacco.create(TobaccoRequest(tobacco: tobacco)),
                        completion: completion as? ResultBlock)
        } else if let tobaccoLine = data as? TobaccoLine {
            sendRequest(object: TobaccoLine.self,
                        target: Api.TobaccoLines.create(tobaccoLine),
                        completion: completion as? ResultBlock)
        } else if let country = data as? Country {
            sendRequest(object: Country.self,
                        target: Api.Countries.create(country),
                        completion: completion as? ResultBlock)
        } else {
            fatalError("не реализовано добавоение в бд для типа \(type(of: data))")
        }
    }

    func setData<T>(_ data: T, completion: ResultBlock<T>?) where T: DataNetworkingServiceProtocol {
        if let manufacturer = data as? Manufacturer {
            sendRequest(object: Manufacturer.self,
                        target: Api.Manufacturer.update(id: manufacturer.uid,
                                                        ManufacturerRequest(manufacturer: manufacturer)),
                        completion: completion as? ResultBlock)
        } else if let tobacco = data as? Tobacco {
            sendRequest(object: Tobacco.self,
                        target: Api.Tobacco.update(id: tobacco.uid,
                                                   TobaccoRequest(tobacco: tobacco)),
                        completion: completion as? ResultBlock)
        } else if let tobaccoLine = data as? TobaccoLine {
            sendRequest(object: TobaccoLine.self,
                        target: Api.TobaccoLines.update(id: tobaccoLine.uid, tobaccoLine),
                        completion: completion as? ResultBlock)
        } else if let country = data as? Country {
            sendRequest(object: Country.self,
                        target: Api.Countries.update(id: country.uid, country),
                        completion: completion as? ResultBlock)
        } else {
            fatalError("не реализовано изменение в бд для типа \(type(of: data))")
        }
    }

    func setDBVersion(_ newVersion: Int, completion: BlockWithParam<HTError?>?) {

    }
}
