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
//            definitionDataSynchronization()
        }
    }
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
    let dataBaseService: DataBaseServiceProtocol

    // MARK: - Dependency UserDefaults
    private let userDefaultsService: UserSettingsServiceProtocol

    // MARK: - Dependency Image
    let imageService: ImageStorageServiceProtocol

    // MARK: - Initializers
    init(getDataNetworkingService: GetDataNetworkingServiceProtocol,
         dataBaseService: DataBaseServiceProtocol,
         userDefaultsService: UserSettingsServiceProtocol,
         imageService: ImageStorageServiceProtocol
    ) {
        self.getDataNetworkingService = getDataNetworkingService
        self.dataBaseService = dataBaseService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
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
    // swiftlint:disable:next function_body_length
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
                        self.notifySystemSubscribers(.errorMessage(error.message, 8.0))
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
                        self.notifySystemSubscribers(.errorMessage(error.message, 8.0))
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
                        self.notifySystemSubscribers(.errorMessage(error.message, 8.0))
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
                        self.notifySystemSubscribers(.errorMessage(error.message, 8.0))
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
            self.dataBaseService.read(type: Taste.self, completion: {
                self.notifySubscribers(with: Taste.self, newState: .update($0))
            }, failure: nil)
            self.dataBaseService.read(type: Tobacco.self, completion: {
                self.notifySubscribers(with: Tobacco.self, newState: .update($0))
            }, failure: nil)
            self.dataBaseService.read(type: Manufacturer.self, completion: {
                self.notifySubscribers(with: Manufacturer.self, newState: .update($0))
            }, failure: nil)
        }
    }

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
                                         completion: CompletionResultBlock<Data>?) {
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
        if isSynchronized && isOfflineMode {
            dataBaseService.read(type: typeData) { data in
                completion?(.success(data))
            } failure: { error in
                completion?(.failure(error))
            }
        } else {
            receiveDataFromNetwork(typeData: typeData, completion: completion)
        }
    }

    func receiveImage(for url: String, completion: CompletionResultBlock<Data>?) {
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

    func receiveTastes(at ids: [Int], completion: ReceiveCompletion<Taste>?) {
        if isSynchronized && isOfflineMode {
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
