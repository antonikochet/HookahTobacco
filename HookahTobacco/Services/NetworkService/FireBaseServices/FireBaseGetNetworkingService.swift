//
//  FireBaseGetNetworkingService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 29.09.2022.
//

import Foundation
import FirebaseFirestore

class FireBaseGetNetworkingService {
    private var firestore = Firestore.firestore()
    private var handlerErrors: NetworkHandlerErrors
    private let workingQueue = DispatchQueue(label: "ru.HookahTobacco.FireBaseGetNeworkingSerivese.workingQueue")

    init(handlerErrors: NetworkHandlerErrors) {
        self.handlerErrors = handlerErrors
    }

    private func definePathCollection<T>(type: T.Type) -> String? {
        switch type.self {
        case is Manufacturer.Type: return NamedFireStore.Collections.manufacturers
        case is Tobacco.Type:      return NamedFireStore.Collections.tobaccos
        case is Taste.Type:        return NamedFireStore.Collections.tastes
        default:                   return nil
        }
    }

    private func receiveData<T>(type: T.Type, completion: ((Result<QuerySnapshot, NetworkError>) -> Void)?) {
        guard let pathCollection = definePathCollection(type: type) else { return }
        firestore.collection(pathCollection).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error { completion?(.failure(self.handlerErrors.handlerError(error)))
            } else if let snapshot = snapshot { completion?(.success(snapshot))
            } else { completion?(.failure(.unknownDataError(pathCollection))) }
        }
    }
}

extension FireBaseGetNetworkingService: GetDataNetworkingServiceProtocol {
    func getManufacturers(completion: GetDataNetworkingServiceCompletion<[Manufacturer]>?) {
        workingQueue.async {
            self.receiveData(type: Manufacturer.self) { result in
                switch result {
                case .success(let snapshot):
                    let manufacturers = snapshot.documents.compactMap { Manufacturer($0.data(), uid: $0.documentID) }
                    completion?(.success(manufacturers))
                case .failure(let error): completion?(.failure(error))
                }
            }
        }
    }

    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?) {
        guard let uid = manufacturer.uid else { return }
        workingQueue.async {
            self.firestore.collection(NamedFireStore.Collections.tobaccos)
                .whereField(NamedFireStore.Documents.Tobacco.idManufacturer, isEqualTo: uid)
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else { return }
                    if let error = error {
                        completion?(.failure(self.handlerErrors.handlerError(error)))
                    } else {
                        if let snapshot = snapshot {
                            let tobaccos = snapshot.documents.map { Tobacco($0.data(), uid: $0.documentID) }
                            completion?(.success(tobaccos))
                        }
                    }
                }
        }
    }

    func getAllTobaccos(completion: GetDataNetworkingServiceCompletion<[Tobacco]>?) {
        workingQueue.async {
            let dispathGroup = DispatchGroup()
            var tastes: [String: Taste]?
            dispathGroup.enter()
            self.getAllTastes { result in
                switch result {
                case .success(let data):
                        tastes = Dictionary(uniqueKeysWithValues: data.map { ($0.uid, $0) })
                case .failure(let error):
                    completion?(.failure(error))
                }
                dispathGroup.leave()
            }
            dispathGroup.wait()
            guard let tastes = tastes else { return }
            self.receiveData(type: Tobacco.self) { result in
                switch result {
                case .success(let snapshot):
                    let tobaccos = snapshot.documents.compactMap { document -> Tobacco? in
                        var dict = document.data()
                        let strTaste = dict[NamedFireStore.Documents.Tobacco.taste] as? [String] ?? []
                        let taste = strTaste.compactMap { tastes[$0] }
                        dict.updateValue(taste, forKey: NamedFireStore.Documents.Taste.taste)
                        return Tobacco(dict, uid: document.documentID)
                    }
                    completion?(.success(tobaccos))
                case .failure(let error): completion?(.failure(error))
                }
            }
        }
    }

    func getAllTastes(completion: GetDataNetworkingServiceCompletion<[Taste]>?) {
        receiveData(type: Taste.self) { result in
            switch result {
            case .success(let snapshot):
                let tastes = snapshot.documents.compactMap { Taste($0.data(), uid: $0.documentID) }
                completion?(.success(tastes))
            case .failure(let error): completion?(.failure(error))
            }
        }
    }

    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?) {
        firestore.collection(NamedFireStore.Collections.system).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                completion?(.failure(self.handlerErrors.handlerError(error)))
            } else {
                guard let data = snapshot?.documents.first,
                      let versionDB = data.data()[NamedFireStore.Documents.System.versionDB] as? Int
                else {
                    completion?(.failure(.dataNotFound("Версия базы данных не была получена")))
                    return
                }
                completion?(.success(versionDB))
            }
        }
    }
}

fileprivate extension Manufacturer {
    init(_ data: [String: Any], uid: String?) {
        self.uid = uid
        self.name = data[NamedFireStore.Documents.Manufacturer.name] as? String ?? ""
        self.country = data[NamedFireStore.Documents.Manufacturer.country] as? String ?? ""
        self.description = data[NamedFireStore.Documents.Manufacturer.description] as? String ?? ""
        self.nameImage = data[NamedFireStore.Documents.Manufacturer.image] as? String ?? ""
        self.link = data[NamedFireStore.Documents.Manufacturer.link] as? String ?? ""
    }
}

fileprivate extension Tobacco {
    init(_ data: [String: Any], uid: String) {
        self.uid = uid
        self.name = data[NamedFireStore.Documents.Tobacco.name] as? String ?? ""
        self.tastes = data[NamedFireStore.Documents.Tobacco.taste] as? [Taste] ?? []
        self.idManufacturer = data[NamedFireStore.Documents.Tobacco.idManufacturer] as? String ?? ""
        self.nameManufacturer = data[NamedFireStore.Documents.Tobacco.nameManufacturer] as? String ?? ""
        self.description = data[NamedFireStore.Documents.Tobacco.description] as? String ?? ""
    }
}

fileprivate extension Taste {
    init?(_ data: [String: Any], uid: String) {
        guard let taste = data[NamedFireStore.Documents.Taste.taste] as? String,
              let typeTaste = data[NamedFireStore.Documents.Taste.type] as? String else { return nil }
        self.uid = uid
        self.taste = taste
        self.typeTaste = typeTaste
    }
}
