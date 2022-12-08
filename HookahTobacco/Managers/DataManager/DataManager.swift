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
            if isSynchronized {
                notifySystemSubscribers(.successMessage("Данные были синхронизированны", 8.0))
            }
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
        Taste.self,
        SystemNotificationType.self
    ]
    private var subscribers: [String: [WeakSubject]]

    // MARK: - Dependency Network
    private let getDataNetworkingService: GetDataNetworkingServiceProtocol

    // MARK: - Dependency DataBase
    let dataBaseService: DataBaseServiceProtocol

    // MARK: - Dependency UserDefaults
    private let userDefaultsService: UserDefaultsServiceProtocol

    // MARK: - Initializers
    init(getDataNetworkingService: GetDataNetworkingServiceProtocol,
         dataBaseService: DataBaseServiceProtocol,
         userDefaultsService: UserDefaultsServiceProtocol
    ) {
        self.getDataNetworkingService = getDataNetworkingService
        self.dataBaseService = dataBaseService
        self.userDefaultsService = userDefaultsService
        subscribers = Dictionary(uniqueKeysWithValues: usedTypes.map {
            (String(describing: $0.self), [WeakSubject]())
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
            notifySystemSubscribers(.errorMessage("""
                Приложение запущено в первый раз и в данный момент не имеет доступа к сети.
                Проверте сетевое подключение и перезагрузите приложение!
                """, 12.0))
        } else if remoteDBVersion == -1 {
            isOfflineMode = true
            isSynchronized = false
            notifySystemSubscribers(.errorMessage("""
                Обновление данные не состоялось, нет подключения к сети!
                Приложение работает в оффлайн режиме!
                """, 10.0))
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
            var tobaccoLines: [TobaccoLine] = []
            var taste: [Taste] = []

            let dispatchGroup = DispatchGroup()
            let queue = DispatchQueue(label: "ru.HookahTobacco.DataManager.syncInLocalDB",
                                      attributes: .concurrent)
            dispatchGroup.enter()
            queue.async {
                self.getDataNetworkingService.receiveData(type: Manufacturer.self) { result in
                    switch result {
                    case .success(let data):
                        manufacturers = data
                    case .failure(let error):
                        self.notifySystemSubscribers(.errorMessage(error.localizedDescription, 8.0))
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            queue.async {
                self.getDataNetworkingService.receiveData(type: TobaccoLine.self) { result in
                    switch result {
                    case .success(let data):
                        tobaccoLines = data
                    case .failure(let error):
                        self.notifySystemSubscribers(.errorMessage(error.localizedDescription, 8.0))
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            queue.async {
                self.getDataNetworkingService.receiveData(type: Tobacco.self) { result in
                    switch result {
                    case .success(let data):
                        tobaccos = data
                    case .failure(let error):
                        self.notifySystemSubscribers(.errorMessage(error.localizedDescription, 8.0))
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            queue.async {
                self.getDataNetworkingService.receiveData(type: Taste.self) { result in
                    switch result {
                    case .success(let data):
                        taste = data
                    case .failure(let error):
                        self.notifySystemSubscribers(.errorMessage(error.localizedDescription, 8.0))
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
                self.dataBaseService.update(entities: tobaccoLines) { dispatchGroup.leave()
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
                self.dataBaseService.add(entities: tobaccoLines) { dispatchGroup.leave()
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
    private func convertNamedImageInImageService(from type: NamedImageManager) -> NamedImageStorage {
        var named: NamedImageStorage
        switch type {
        case .manufacturerImage(let nameImage):
            named = NamedImageStorage.manufacturer(nameImage: nameImage)
        case .tobaccoImage(let manufacturer, let uid, let type):
            named = NamedImageStorage.tobacco(manufacturer: manufacturer, uid: uid, type: type)
        }
        return named
    }

    // MARK: - Private Methods for working with network
    private func receiveDataFromNetwork<T>(typeData: T.Type,
                                           completion: ReceiveDataManagerCompletion<T>?
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
    func receiveData<T: DataManagerType>(typeData: T.Type, completion: ReceiveDataManagerCompletion<T>?) {
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
        // TODO: - убрать отсюда получение табака из сети и сделать получение из бд
        getDataNetworkingService.getTobaccos(for: manufacturer) { result in
            switch result {
            case .success(let tobaccos):
                completion?(.success(tobaccos))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func receiveTastes(at ids: [String], completion: ReceiveDataManagerCompletion<Taste>?) {
        if isSynchronized || isOfflineMode {
            dataBaseService.read(type: Taste.self) { tastes in
                let setIds = Set(ids)
                let needTastes = tastes.filter { setIds.contains($0.uid) }
                completion?(.success(needTastes))
            } failure: { error in
                completion?(.failure(error))
            }

        } else {
            getDataNetworkingService.receiveData(type: Taste.self) { result in
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
