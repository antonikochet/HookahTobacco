//
//  FireBaseGetNetworkManager.swift
//  HookahTobacco
//
//  Created by антон кочетков on 29.09.2022.
//

import Foundation
import FirebaseFirestore

class FireBaseGetNetworkManager: GetDataBaseNetworkingProtocol {
    private var db = Firestore.firestore()
    private var handlerErrors: NetworkHandlerErrors
    
    init(handlerErrors: NetworkHandlerErrors) {
        self.handlerErrors = handlerErrors
    }
    
    func getManufacturers(completion: @escaping (Result<[Manufacturer], NetworkError>) -> Void) {
        db.collection(NamedFireStore.Collections.manufacturers).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(self.handlerErrors.handlerError(error)))
            } else {
                if let snapshot = snapshot {
                    let manufacturers = snapshot.documents.map { Manufacturer($0.data(), uid: $0.documentID) }
                    completion(.success(manufacturers))
                }
            }
        }
    }
    
    func getTobaccos(for manufacturer: Manufacturer, completion: @escaping (Result<[Tobacco], NetworkError>) -> Void) {
        guard let uid = manufacturer.uid else { return }
        db.collection(NamedFireStore.Collections.tobaccos)
            .whereField(NamedFireStore.Documents.Tobacco.idManufacturer, isEqualTo: uid)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    completion(.failure(self.handlerErrors.handlerError(error)))
                } else {
                    if let snapshot = snapshot {
                        let tobaccos = snapshot.documents.map { Tobacco($0.data(), uid: $0.documentID) }
                        completion(.success(tobaccos))
                    }
                }
            }
    }
    
    func getAllTobaccos(completion: @escaping (Result<[Tobacco], NetworkError>) -> Void) {
        db.collection(NamedFireStore.Collections.tobaccos).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(self.handlerErrors.handlerError(error)))
            } else {
                if let snapshot = snapshot {
                    let tobaccos = snapshot.documents.map { Tobacco($0.data(), uid: $0.documentID) }
                    completion(.success(tobaccos))
                }
            }
        }
    }
    
    func getAllTastes(completion: @escaping (Result<[Taste], NetworkError>) -> Void) {
        db.collection(NamedFireStore.Collections.tastes).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(self.handlerErrors.handlerError(error)))
            } else {
                if let snapshot = snapshot {
                    let tastes = snapshot.documents.compactMap { Taste($0.data(), uid: $0.documentID) }
                    completion(.success(tastes))
                }
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
    init(_ data: [String: Any], uid: String? ) {
        self.uid = uid
        self.name = data[NamedFireStore.Documents.Tobacco.name] as? String ?? ""
        self.taste = data[NamedFireStore.Documents.Tobacco.taste] as? [Int] ?? []
        self.idManufacturer = data[NamedFireStore.Documents.Tobacco.idManufacturer] as? String ?? ""
        self.nameManufacturer = data[NamedFireStore.Documents.Tobacco.nameManufacturer] as? String ?? ""
        self.description = data[NamedFireStore.Documents.Tobacco.description] as? String ?? ""
    }
}

fileprivate extension Taste {
    init?(_ data: [String: Any], uid: String?) {
        guard let uid = uid,
              let id = Int(uid),
              let taste = data[NamedFireStore.Documents.Taste.taste] as? String,
              let typeTaste = data[NamedFireStore.Documents.Taste.type] as? String else { return nil }
        self.id = id
        self.taste = taste
        self.typeTaste = typeTaste
        
    }
}
