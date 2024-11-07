//
//  DataManager.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

class DataManager {
    // MARK: - Private properties
    private var isSynchronized: Bool = false {
        didSet {
            if isSynchronized {
                notifySystemSubscribers(.successMessage("Данные были синхронизированны", 8.0))
            }
        }
    }
    private var isOfflineMode: Bool = true

    private let usedTypes: [Any.Type] = [
        Manufacturer.self,
        Tobacco.self,
        Taste.self,
        SystemNotificationType.self
    ]
    private var subscribers: [String: [WeakSubject]]

    let imageWorkingQueue = DispatchQueue(label: "ru.HookahTobacco.DataManager.getImage")

    // MARK: - Dependency Network
    private let getDataNetworkingService: GetDataNetworkingServiceProtocol

    // MARK: - Dependency DataBase

    // MARK: - Dependency Image
    let imageService: ImageStorageServiceProtocol

    // MARK: - Initializers
    init(getDataNetworkingService: GetDataNetworkingServiceProtocol,
         imageService: ImageStorageServiceProtocol
    ) {
        self.getDataNetworkingService = getDataNetworkingService
        self.imageService = imageService
        subscribers = Dictionary(uniqueKeysWithValues: usedTypes.map {
            (String(describing: $0.self), [WeakSubject]())
        })
    }

    // MARK: - Public methods

    // MARK: - Private methods

    // MARK: - Private Methods for working with network
    private func receiveDataFromNetwork<T>(typeData: T.Type,
                                           completion: ReceiveCompletion<T>?
    ) where T: DataNetworkingServiceProtocol {
        getDataNetworkingService.receiveData(type: typeData) { result in
            switch result {
            case .success(let data):
                completion?(.success(data))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    private func convertNamedImageInImageService(from url: String) -> NamedImageStorage? {
        var named: NamedImageStorage?
        if let url = URL(string: url) {
            let pathComponents = url.pathComponents
            if pathComponents.contains(where: { $0 == "tobaccos" }) {
                if let manufacturer = pathComponents.dropLast().last,
                   let nameFile = pathComponents.last {
                    named = NamedImageStorage.tobacco(manufacturer: manufacturer, name: nameFile)
                }
            } else {
                if let nameFile = pathComponents.last {
                    named = NamedImageStorage.manufacturer(nameImage: nameFile)
                }
            }
        }
        return named
    }

    private func receiveImageFromNetwork(for url: String,
                                         completion: ResultBlock<Data>?) {
        getDataNetworkingService.receiveImage(for: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                if let named = self.convertNamedImageInImageService(from: url) {
                    // TODO: - вернуть обратно сохранение изображений
//                    do {
//                        _ = try self.imageService.saveImage(image, for: named)
//                    } catch {
//                        print(error)
//                    }
                }
                completion?(.success(image))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    // MARK: - Notification subscribers methods
    func notifySubscribers<T>(with type: T.Type, newState: UpdateDataNotification<[T]>) {
        let nameType = String(describing: type.self)
        print("Пришло обновление для типа: \(type.self)")
        if let subscribers = subscribers[nameType] {
            subscribers.forEach {
                ($0.value as? UpdateDataSubscriberProtocol)?.notify(for: type, notification: newState)
            }
        }
    }
    func notifySystemSubscribers(_ notification: SystemNotification) {
        let nameType = String(describing: SystemNotificationType.self)
        print("Пришло системное оповещение")
        if let subscribers = subscribers[nameType] {
            DispatchQueue.main.async {
                subscribers.forEach { ($0.value as? SystemSubscriberProtocol)?.notify(notification) }
            }
        }
    }
}

// MARK: - DataManagerProtocol implementation
extension DataManager: DataManagerProtocol {
    func receiveData<T: DataManagerType>(typeData: T.Type, completion: ReceiveCompletion<T>?) {
        receiveDataFromNetwork(typeData: typeData, completion: completion)
    }

    func receiveImage(for url: String, completion: ResultBlock<Data>?) {
        imageWorkingQueue.async {
            do {
                if let named = self.convertNamedImageInImageService(from: url) {
                    completion?(.success(try self.imageService.receiveImage(for: named)))
                } else {
                    self.receiveImageFromNetwork(for: url, completion: completion)
                }
            } catch {
                self.receiveImageFromNetwork(for: url, completion: completion)
            }
        }
        getDataNetworkingService.receiveImage(for: url, completion: completion)
    }
}

// MARK: - ObserverProtocol implementation
extension DataManager: ObserverProtocol {
    func subscribe<T>(to type: T.Type, subscriber: SubscriberProtocol) {
        let nameType = String(describing: type.self)
        if subscribers[nameType] != nil {
            subscribers[nameType]?.append(WeakSubject(subscriber))
            print("Подписчик \(subscriber) был успешно добавлен в подписки на обновления для типа: \(type.self)")
        } else {
            print("Передан неверный тип \(type.self) для подписки")
        }
    }

    func unsubscribe<T>(to type: T.Type, subscriber: SubscriberProtocol) {
        let nameType = String(describing: type.self)
        if subscribers[nameType] != nil {
            if let index = subscribers[nameType]?.firstIndex(where: { return $0.value == nil }) {
                subscribers[nameType]?.remove(at: index)
                print("Подписчик был удален из подписок на обновления для типа: \(type.self)")
            } else {
                print("Переданный подписчик отсутствует в подписках типа: \(type.self)")
            }
        } else {
            print("Передан неверный тип для отписки на ObserverProtocol типа: \(type.self)")
        }
    }
}
