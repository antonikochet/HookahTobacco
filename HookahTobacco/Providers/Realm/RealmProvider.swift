//
//  RealmProvider.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import Foundation
import RealmSwift
import Realm

typealias RealmBlock<T> = (Realm, T) -> Void

class RealmProvider {
    // MARK: - Private properties
    private let htRealm: HTRealmProtocol
    private let workingQueue: DispatchQueue

    private var configuration: Realm.Configuration?
    private var contextRealm: Realm? {
        do {
            guard let config = configuration else { return nil }

            let realm = try Realm(configuration: config)
            realm.refresh()
            realm.autorefresh = true
            return realm
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    // MARK: - Initialization
    init(htRealm: HTRealmProtocol) {
        self.htRealm = htRealm
        self.workingQueue = htRealm.workingQueue
        configureRealm()
    }

    // MARK: - Private methods
    private func configureRealm() {
        var docDirectory: URL?
        do {
            docDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        var deleteRealmIfMigrationNeeded: Bool = false
        #if DEBUG
        deleteRealmIfMigrationNeeded = true
        #endif

        configuration = Realm.Configuration(
            fileURL: docDirectory?.appendingPathComponent(htRealm.fileName),
            schemaVersion: htRealm.realmVersion,
            migrationBlock: htRealm.migrationBlock,
            deleteRealmIfMigrationNeeded: deleteRealmIfMigrationNeeded,
            objectTypes: htRealm.realmTypes
        )
        print("Путь до базы данных: " + (configuration?.fileURL?.path ?? "Файл не найден"))
    }

    private func readFromStore(_ type: Object.Type,
                               completion: DataBaseObjectsHandler<ThreadSafe<Results<Object>>>?) {
        workingQueue.async { [weak self] in
            autoreleasepool {
                guard let self = self else { return }
                guard let realm =  self.contextRealm else { return }

                let realmObjects = realm.objects(type)
                completion?(ThreadSafe(wrappedValue: realmObjects))
            }
        }
    }

    private func writeToStore(object: Object,
                              failure: FailureCompletionBlock?,
                              block: @escaping RealmBlock<Object>) {
        workingQueue.async { [weak self] in
            autoreleasepool {
                guard let self = self else { return }
                do {
                    guard let realm = self.contextRealm else { return }
                    try realm.write {
                        block(realm, object)
                    }
                } catch {
                    failure?(error)
                }
            }
        }
    }

    private func writeToStore<S: Sequence>(objects: S,
                                           failure: FailureCompletionBlock?,
                                           block: @escaping RealmBlock<S>
    ) where S.Element: Object {
        workingQueue.async { [weak self] in
            autoreleasepool {
                guard let self = self else { return }
                do {
                    guard let realm = self.contextRealm else { return }
                    try realm.write {
                        block(realm, objects)
                    }
                } catch {
                    failure?(error)
                }
            }
        }
    }
}

// MARK: - RealmProviderProtocol implementation
extension RealmProvider: RealmProviderProtocol {
    func read(type: Object.Type,
              completion: DataBaseObjectsHandler<ThreadSafe<Results<Object>>>?) {
        readFromStore(type, completion: completion)
    }

    func write(element: Object,
               completion: DataBaseOperationCompletion?,
               failure: FailureCompletionBlock?) {
        let writeBlock: RealmBlock<Object> = { realm, object in
            realm.add(object)
            completion?()
        }
        writeToStore(object: element, failure: failure, block: writeBlock)
    }

    func write<S>(elements: S,
                  completion: DataBaseOperationCompletion?,
                  failure: FailureCompletionBlock?) where S: Sequence, S.Element: Object {
        let writeBlock: RealmBlock<S> = { realm, objects in
            realm.add(objects)
            completion?()
        }
        writeToStore(objects: elements, failure: failure, block: writeBlock)
    }

    func update(element: Object,
                completion: DataBaseOperationCompletion?,
                failure: FailureCompletionBlock?) {
        let updateBlock: RealmBlock<Object> = { realm, object in
            realm.add(object, update: .modified)
            completion?()
        }
        writeToStore(object: element, failure: failure, block: updateBlock)
    }

    func update<S>(elements: S,
                   completion: DataBaseOperationCompletion?,
                   failure: FailureCompletionBlock?) where S: Sequence, S.Element: Object {
        let updateBlock: RealmBlock<S> = { realm, objects in
            realm.add(objects, update: .modified)
            completion?()
        }
        writeToStore(objects: elements, failure: failure, block: updateBlock)
    }

    func delete(object: Object,
                completion: DataBaseOperationCompletion?,
                failure: FailureCompletionBlock?) {
        let deleteBlock: RealmBlock<Object> = { realm, object in
            realm.delete(object)
            completion?()
        }
        writeToStore(object: object, failure: failure, block: deleteBlock)
    }

    func delete<S>(objects: S,
                   completion: DataBaseOperationCompletion?,
                   failure: FailureCompletionBlock?) where S: Sequence, S.Element: Object {
        let deleteBlock: RealmBlock<S> = { realm, objects in
            realm.delete(objects)
            completion?()
        }
        writeToStore(objects: objects, failure: failure, block: deleteBlock)
    }
}
