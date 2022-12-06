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
        case is TobaccoLine.Type:  return NamedFireStore.Collections.tobaccoLines
        default:                   return nil
        }
    }

    private func receiceManufacturers(completion: GetDataNetworkingServiceCompletion<[Manufacturer]>?) {
        workingQueue.async {
            let dispathGroup = DispatchGroup()
            var tobaccoLines: [String: TobaccoLine]?
            dispathGroup.enter()
            self.receiveData(type: TobaccoLine.self) { result in
                switch result {
                case .success(let data):
                        tobaccoLines = Dictionary(uniqueKeysWithValues: data.map { ($0.uid, $0) })
                case .failure(let error):
                    completion?(.failure(error))
                }
                dispathGroup.leave()
            }
            dispathGroup.wait()
            guard let tobaccoLines = tobaccoLines else { return }
            self.request(type: Manufacturer.self) { result in
                switch result {
                case .success(let snapshot):
                    let manufacturers = snapshot.documents.compactMap { document -> Manufacturer? in
                        var dict = document.data()
                        let uidTobaccoLines = dict[NamedFireStore.Documents.Manufacturer.lines] as? [String] ?? []
                        let tobaccoLines = uidTobaccoLines.compactMap { tobaccoLines[$0] }
                        dict.updateValue(tobaccoLines, forKey: NamedFireStore.Documents.Manufacturer.lines)
                        return Manufacturer(dict, uid: document.documentID)
                    }
                    completion?(.success(manufacturers))
                case .failure(let error): completion?(.failure(error))
                }
            }
        }
    }
    private func receiveTobaccos(completion: GetDataNetworkingServiceCompletion<[Tobacco]>?) {
        workingQueue.async {
            let dispathGroup = DispatchGroup()
            var tastes: [String: Taste]?
            var lines: [String: TobaccoLine]?
            dispathGroup.enter()
            self.receiveData(type: Taste.self) { result in
                switch result {
                case .success(let data):
                        tastes = Dictionary(uniqueKeysWithValues: data.map { ($0.uid, $0) })
                case .failure(let error):
                    completion?(.failure(error))
                }
                dispathGroup.leave()
            }
            dispathGroup.enter()
            self.receiveData(type: TobaccoLine.self) { result in
                switch result {
                case .success(let data):
                        lines = Dictionary(uniqueKeysWithValues: data.map { ($0.uid, $0) })
                case .failure(let error):
                    completion?(.failure(error))
                }
                dispathGroup.leave()
            }
            dispathGroup.wait()
            guard let tastes = tastes else { return }
            self.request(type: Tobacco.self) { result in
                switch result {
                case .success(let snapshot):
                    let tobaccos = snapshot.documents.compactMap { document -> Tobacco? in
                        var dict = document.data()
                        let strTaste = dict[NamedFireStore.Documents.Tobacco.taste] as? [String] ?? []
                        let taste = strTaste.compactMap { tastes[$0] }
                        let strLine = dict[NamedFireStore.Documents.Tobacco.line] as? String
                        let line = strLine != nil ? lines?[strLine!] : nil
                        dict.updateValue(taste, forKey: NamedFireStore.Documents.Tobacco.taste)
                        dict.updateValue(line as Any, forKey: NamedFireStore.Documents.Tobacco.line)
                        return Tobacco(dict, uid: document.documentID)
                    }
                    completion?(.success(tobaccos))
                case .failure(let error): completion?(.failure(error))
                }
            }
        }
    }
    private func receiveTastes(completion: GetDataNetworkingServiceCompletion<[Taste]>?) {
        request(type: Taste.self) { result in
            switch result {
            case .success(let snapshot):
                let tastes = snapshot.documents.compactMap { Taste($0.data(), uid: $0.documentID) }
                completion?(.success(tastes))
            case .failure(let error): completion?(.failure(error))
            }
        }
    }
    private func receiveTobaccoLines(completion: GetDataNetworkingServiceCompletion<[TobaccoLine]>?) {
        request(type: TobaccoLine.self) { result in
            switch result {
            case .success(let snapshot):
                let tastes = snapshot.documents.compactMap { TobaccoLine($0.data(), uid: $0.documentID) }
                completion?(.success(tastes))
            case .failure(let error): completion?(.failure(error))
            }
        }
    }

    private func request<T>(type: T.Type, completion: ((Result<QuerySnapshot, NetworkError>) -> Void)?) {
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
    func receiveData<T: DataNetworkingServiceProtocol>(
        type: T.Type,
        completion: GetDataNetworkingServiceCompletion<[T]>?) {
        switch type.self {
        case is Manufacturer.Type:
            receiceManufacturers(completion: completion as? GetDataNetworkingServiceCompletion<[Manufacturer]>)
        case is Tobacco.Type:
            receiveTobaccos(completion: completion as? GetDataNetworkingServiceCompletion<[Tobacco]>)
        case is Taste.Type:
            receiveTastes(completion: completion as? GetDataNetworkingServiceCompletion<[Taste]>)
        case is TobaccoLine.Type:
            receiveTobaccoLines(completion: completion as? GetDataNetworkingServiceCompletion<[TobaccoLine]>)
        default: completion?(.failure(.dataNotFound("Тип \(type) не может быть использован для получения данных")))
        }
    }

    func getTobaccos(for manufacturer: Manufacturer, completion: GetDataNetworkingServiceCompletion<[Tobacco]>?) {
        guard !manufacturer.uid.isEmpty else { return }
        workingQueue.async {
            self.firestore.collection(NamedFireStore.Collections.tobaccos)
                .whereField(NamedFireStore.Documents.Tobacco.idManufacturer, isEqualTo: manufacturer.uid)
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else { return }
                    if let error = error {
                        completion?(.failure(self.handlerErrors.handlerError(error)))
                    } else {
                        if let snapshot = snapshot {
                            let tobaccos = snapshot.documents.compactMap { Tobacco($0.data(), uid: $0.documentID) }
                            completion?(.success(tobaccos))
                        }
                    }
                }
        }
    }

    func getDataBaseVersion(completion: GetDataNetworkingServiceCompletion<Int>?) {
        firestore.collection(NamedFireStore.Collections.system)
                 .getDocuments(source: .server) { [weak self] snapshot, error in
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
