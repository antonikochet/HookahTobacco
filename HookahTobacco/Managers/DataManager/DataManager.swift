//
//  DataManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation

class DataManager {
    // MARK: - Private properties
    private var isSynchronized: Bool = false {
        didSet {
// FIXME: добавить функцию по синхрониции которая будет выполняться при изменение синхронизации
            print("Статус синхронизации данных был изменен на \(isSynchronized ? "синхронизировано" : "не синхронизировано")")
        }
    }
    private var isOfflineMode: Bool = true

    private var remoteDBVersion: Int = -1 {
        didSet {
            definitionDataSynchronization()
        }
    }
    private let usedTypes: [Any.Type] = [
        Manufacturer.self,
        Tobacco.self,
        Taste.self
    ]
    private var subscribers: [String: [DataManagerSubscriberProtocol]]

    private let imageWorkingQueue = DispatchQueue(label: "ru.HookahTobacco.DataManager.getImage")

    // MARK: - Dependency Network
    private let getDataNetworkingService: GetDataNetworkingServiceProtocol
    private let getImageNetworingService: GetImageNetworkingServiceProtocol

    // MARK: - Dependency DataBase
    private let dataBaseService: DataBaseServiceProtocol

    // MARK: - Dependency Image
    private let imageService: ImageServiceProtocol

    // MARK: - Dependency UserDefaults
    private let userDefaultsService: UserDefaultsServiceProtocol

    // MARK: - Initializers
    init(getDataNetworkingService: GetDataNetworkingServiceProtocol,
         getImageNetworingService: GetImageNetworkingServiceProtocol,
         dataBaseService: DataBaseServiceProtocol,
         imageService: ImageServiceProtocol,
         userDefaultsService: UserDefaultsServiceProtocol
    ) {
        self.getDataNetworkingService = getDataNetworkingService
        self.getImageNetworingService = getImageNetworingService
        self.dataBaseService = dataBaseService
        self.imageService = imageService
        self.userDefaultsService = userDefaultsService
        subscribers = Dictionary(uniqueKeysWithValues: usedTypes.map {
            (String(describing: $0.self), [DataManagerSubscriberProtocol]())
        })
    }

    // MARK: - Public methods
    func start() {
        self.getDataNetworkingService.getDataBaseVersion { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let version):
                self.remoteDBVersion = version
                self.isOfflineMode = false
            case .failure(let error):
                self.remoteDBVersion = -1
                self.isOfflineMode = true
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Private methods
    private func definitionDataSynchronization() {
        let localDBVersion = userDefaultsService.getDataBaseVersion()
        if remoteDBVersion == -1 && localDBVersion == -1 {
            // FIXME: - Когда будут делаться подписки сделать повторный запрос и уведомление пользователя о ошибки
            fatalError("Приложение запущено первый раз и нет доступа к сети")
        } else if remoteDBVersion == -1 {
            isOfflineMode = true
            isSynchronized = false
            return
        }
        if localDBVersion == remoteDBVersion {
            isSynchronized = true
        } else if localDBVersion < remoteDBVersion || localDBVersion == -1 {
            syncDataInLocalDatabase(oldVersion: localDBVersion)
        }
    }

    private func syncDataInLocalDatabase(oldVersion: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            var manufacturers: [Manufacturer] = []
            var tobaccos: [Tobacco] = []
            var taste: [Taste] = []

            let dispatchGroup = DispatchGroup()
            let queue = DispatchQueue(label: "ru.HookahTobacco.DataManager.syncInLocalDB",
                                      attributes: .concurrent)
            dispatchGroup.enter()
            queue.async {
                self.getDataNetworkingService.getManufacturers { result in
                    switch result {
                    case .success(let data):
                        manufacturers = data
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            queue.async {
                self.getDataNetworkingService.getAllTobaccos { result in
                    switch result {
                    case .success(let data):
                        tobaccos = data
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            queue.async {
                self.getDataNetworkingService.getAllTastes { result in
                    switch result {
                    case .success(let data):
                        taste = data
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.wait()
            if oldVersion != -1 {
                dispatchGroup.enter()
                self.dataBaseService.update(entities: taste) { dispatchGroup.leave()
                } failure: { error in print(error); dispatchGroup.leave() }
                dispatchGroup.enter()
                self.dataBaseService.update(entities: tobaccos) { dispatchGroup.leave()
                } failure: { error in print(error); dispatchGroup.leave() }
                dispatchGroup.enter()
                self.dataBaseService.update(entities: manufacturers) { dispatchGroup.leave()
                } failure: { error in print(error); dispatchGroup.leave() }
            } else {
                dispatchGroup.enter()
                self.dataBaseService.add(entities: taste) { dispatchGroup.leave()
                } failure: { error in print(error); dispatchGroup.leave() }
                dispatchGroup.enter()
                self.dataBaseService.add(entities: tobaccos) { dispatchGroup.leave()
                } failure: { error in print(error); dispatchGroup.leave() }
                dispatchGroup.enter()
                self.dataBaseService.add(entities: manufacturers) { dispatchGroup.leave()
                } failure: { error in print(error); dispatchGroup.leave() }
            }
            dispatchGroup.wait()
            self.userDefaultsService.setDataBaseVersion(self.remoteDBVersion)
            self.isSynchronized = true
            self.notifySubscribers(with: Taste.self, newState: .update(taste))
            self.notifySubscribers(with: Tobacco.self, newState: .update(tobaccos))
            self.notifySubscribers(with: Manufacturer.self, newState: .update(manufacturers))
        }
    }

    private func convertNamedImageInNamedImageNetwork(from type: NamedImageManager) -> NamedFireStorage {
        var named: NamedFireStorage
        switch type {
        case .manufacturerImage(let nameImage):
            named = NamedFireStorage.manufacturerImage(name: nameImage)
        case .tobaccoImage(let manufacturer, let uid, let type):
            named = NamedFireStorage.tobaccoImage(manufacturer: manufacturer, uid: uid, type: type)
        }
        return named
    }
    private func convertNamedImageInImageService(from type: NamedImageManager) -> NamedImage {
        var named: NamedImage
        switch type {
        case .manufacturerImage(let nameImage):
            named = NamedImage.manufacturer(nameImage: nameImage)
        case .tobaccoImage(let manufacturer, let uid, let type):
            named = NamedImage.tobacco(manufacturer: manufacturer, uid: uid, type: type)
        }
        return named
    }
    // swiftlint:disable force_cast
    // MARK: - Private Methods for working with network
    private func receiveDataFromNetwork<T>(typeData: T.Type,
                                           completion: ReceiveDataManagerCompletion<T>?) {
        switch typeData {
        case is Manufacturer.Type:
            getDataNetworkingService.getManufacturers { result in
                switch result {
                case .success(let manufacturers):
                    completion?(.success(manufacturers as! [T]))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        case is Tobacco.Type:
            getDataNetworkingService.getAllTobaccos { result in
                switch result {
                case .success(let tobaccos):
                    completion?(.success(tobaccos as! [T]))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        case is Taste.Type:
            getDataNetworkingService.getAllTastes { result in
                switch result {
                case .success(let tastes):
                    completion?(.success(tastes as! [T]))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        default: return
        }
    }
    // swiftlint:enable force_cast

    private func receiveImageFromNetwork(for type: NamedImageManager,
                                         completion: @escaping (Result<Data, Error>) -> Void) {
        let named = convertNamedImageInNamedImageNetwork(from: type)
        getImageNetworingService.getImage(for: named) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                let named = self.convertNamedImageInImageService(from: type)
                do {
                    _ = try self.imageService.saveImage(image, for: named)
                } catch {
                    print(error)
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func notifySubscribers<T>(with type: T.Type, newState: NewStateType<[T]>) {
        let nameType = String(describing: type.self)
        print("Пришло обновление для типа: \(type.self)")
        if let subscribers = subscribers[nameType] {
            subscribers.forEach { $0.notify(for: type, newState: newState) }
        }
    }
}

// MARK: - DataManagerProtocol implementation
extension DataManager: DataManagerProtocol {
    func receiveData<T>(typeData: T.Type, completion: ReceiveDataManagerCompletion<T>?) {
        if isSynchronized || isOfflineMode {
            dataBaseService.read(type: typeData) { data in
                completion?(.success(data))
            } failure: { error in
                completion?(.failure(error))
            }
        } else {
            receiveDataFromNetwork(typeData: typeData, completion: completion)
        }
    }

    func receiveTobaccos(for manufacturer: Manufacturer, completion: ReceiveDataManagerCompletion<Tobacco>?) {
        getDataNetworkingService.getTobaccos(for: manufacturer) { result in
            switch result {
            case .success(let tobaccos):
                completion?(.success(tobaccos))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func receiveTastes(at ids: [Int], completion: ReceiveDataManagerCompletion<Taste>?) {
        if isSynchronized || isOfflineMode {
            dataBaseService.read(type: Taste.self) { tastes in
                let setIds = Set(ids)
                let needTastes = tastes.filter { setIds.contains($0.uid) }
                completion?(.success(needTastes))
            } failure: { error in
                completion?(.failure(error))
            }

        } else {
            getDataNetworkingService.getAllTastes { result in
                switch result {
                case .success(let tastes):
                    let setIds = Set(ids)
                    let needTastes = tastes.filter { setIds.contains($0.uid) }
                    completion?(.success(needTastes))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
    }
}

// MARK: - ImageManagerProtocol implementation
extension DataManager: ImageManagerProtocol {
    func getImage(for type: NamedImageManager, completion: @escaping (Result<Data, Error>) -> Void) {
        imageWorkingQueue.async {
            if self.isSynchronized || self.isOfflineMode {
                do {
                    let named = self.convertNamedImageInImageService(from: type)
                    completion(.success(try self.imageService.receiveImage(for: named)))
                } catch {
                    if self.isOfflineMode {
                        completion(.failure(error))
                    } else {
                        self.receiveImageFromNetwork(for: type, completion: completion)
                    }
                }
            } else {
                self.receiveImageFromNetwork(for: type, completion: completion)
            }
        }
    }
}

// MARK: - UpdateDataManagerObserverProtocol implementation
extension DataManager: UpdateDataManagerObserverProtocol {
    func subscribe<T>(to type: T.Type, subscriber: DataManagerSubscriberProtocol) {
        let nameType = String(describing: type.self)
        if subscribers[nameType] != nil {
            subscribers[nameType]?.append(subscriber)
            print("Подписчик \(subscriber) был успешно добавлен в подписки на обновления для типа: \(type.self)")
        } else {
            print("Передан неверный тип \(type.self) для подписки")
        }
    }

    func unsubscribe<T>(to type: T.Type, subscriber: DataManagerSubscriberProtocol) {
        let nameType = String(describing: type.self)
        if subscribers[nameType] != nil {
            if let index = subscribers[nameType]?.firstIndex(where: { $0 === subscriber }) {
                subscribers[nameType]?.remove(at: index)
                print("Подписчик был удален из подписок на обновления для типа: \(type.self)")
            } else {
                print("Переданный подписчик отсутствует в подписках типа: \(type.self)")
            }
        } else {
            print("Передан неверный тип для отписки на UpdateDataManagerObserverProtocol типа: \(type.self)")
        }
    }
}
