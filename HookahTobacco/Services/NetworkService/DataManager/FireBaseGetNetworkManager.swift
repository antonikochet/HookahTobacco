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
    
    func getManufacturers(completion: @escaping (Result<[Manufacturer], Error>) -> Void) {
        db.collection(NamedFireStore.Collections.manufacturers).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    let manufacturers = snapshot.documents.map { Manufacturer($0.data(), uid: $0.documentID) }
                    completion(.success(manufacturers))
                }
            }
        }
    }
    
    func getTobaccos(for manufacturer: Manufacturer, completion: @escaping (Result<[Tobacco], Error>) -> Void) {
        guard let uid = manufacturer.uid else { return }
        db.collection(NamedFireStore.Collections.tobaccos)
            .whereField(NamedFireStore.Documents.Tobacco.idManufacturer, isEqualTo: uid)
            .getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    let tobaccos = snapshot.documents.map { Tobacco($0.data(), uid: $0.documentID) }
                    completion(.success(tobaccos))
                }
            }
        }
    }
    
    func getAllTobaccos(completion: @escaping (Result<[Tobacco], Error>) -> Void) {
        db.collection(NamedFireStore.Collections.tobaccos).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    let tobaccos = snapshot.documents.map { Tobacco($0.data(), uid: $0.documentID) }
                    completion(.success(tobaccos))
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
    }
}

fileprivate extension Tobacco {
    init(_ data: [String: Any], uid: String? ) {
        self.uid = uid
        self.name = data[NamedFireStore.Documents.Tobacco.name] as? String ?? ""
        self.taste = data[NamedFireStore.Documents.Tobacco.taste] as? [String] ?? []
        self.idManufacturer = data[NamedFireStore.Documents.Tobacco.idManufacturer] as? String ?? ""
        self.nameManufacturer = data[NamedFireStore.Documents.Tobacco.nameManufacturer] as? String ?? ""
        self.description = data[NamedFireStore.Documents.Tobacco.description] as? String ?? ""
    }
}
