//
//  AdminDataManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.12.2022.
//

import Foundation

class AdminDataManager: DataManager {
    // MARK: - Private properties

    // MARK: - Dependency Network
    private let setDataNetworkingService: SetDataNetworkingServiceProtocol

    init(getDataNetworkingService: GetDataNetworkingServiceProtocol,
         dataBaseService: DataBaseServiceProtocol,
         userDefaultsService: UserSettingsServiceProtocol,
         setDataNetworkingService: SetDataNetworkingServiceProtocol,
         imageService: ImageStorageServiceProtocol
    ) {
        self.setDataNetworkingService = setDataNetworkingService
        super.init(getDataNetworkingService: getDataNetworkingService,
                   dataBaseService: dataBaseService,
                   userDefaultsService: userDefaultsService,
                   imageService: imageService)
    }

    private func notifySubscribers<T>(_ type: T.Type) {
        DispatchQueue.global(qos: .utility).asyncAfter(wallDeadline: .now() + 2.0) {
            self.dataBaseService.read(type: type, completion: { [weak self] data in
                guard let self = self else { return }
                self.notifySubscribers(with: type, newState: .update(data))
            }, failure: nil)
        }
    }

    private func addDataViaNetwork<T>(
        _ data: T,
        completion: AdminDataManagerCompletion<T>?
    ) where T: DataNetworkingServiceProtocol {
        setDataNetworkingService.addData(data) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newData):
                print(type(of: newData), newData.uid)
                completion?(.success(newData))
//                self.notifySubscribers(T.self)
//                self.dataBaseService.add(entity: newData) {
//                    completion?(.success(newData))
//                    self.notifySubscribers(T.self)
//                } failure: { error in
//                    completion?(.failure(error))
//                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    private func setDataViaNetwork<T>(
        _ data: T,
        completion: AdminDataManagerCompletion<T>?
    ) where T: DataNetworkingServiceProtocol {
        setDataNetworkingService.setData(data) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                completion?(.success(response))
//                self.notifySubscribers(T.self)
//                self.dataBaseService.update(entity: data) {
//                    completion?(nil)
//                    self.notifySubscribers(T.self)
//                } failure: { error in
//                    completion?(error)
//                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

extension AdminDataManager: AdminDataManagerProtocol {
    func addData<T: DataManagerType>(_ data: T, completion: AdminDataManagerCompletion<T>?) {
        addDataViaNetwork(data, completion: completion)
    }

    func setData<T: DataManagerType>(_ data: T, completion: AdminDataManagerCompletion<T>?) {
        setDataViaNetwork(data, completion: completion)
    }
}
