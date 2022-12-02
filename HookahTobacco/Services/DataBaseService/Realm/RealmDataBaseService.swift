//
//  RealmDataBaseService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import RealmSwift

class RealmDataBaseService {
    // MARK: - Private properties
    private let realmProvider: RealmProviderProtocol
    private var cacheData: [String: Results<Object>] = [:]
    private var usedType: [(enity: Any.Type, realm: Object.Type)] = [
        (Manufacturer.self, ManufacturerRealmObject.self),
        (Tobacco.self, TobaccoRealmObject.self),
        (Taste.self, TasteRealmObject.self),
        (TobaccoLine.self, TobaccoLineRealmObject.self)
    ]

    // MARK: - Initialization
    init(realmProvider: RealmProviderProtocol) {
        self.realmProvider = realmProvider
    }

    // MARK: - Working with Types
    private func receiveRealmType<T>(from type: T.Type) -> Object.Type? {
        for useType in usedType where useType.enity == type {
            return useType.realm
        }
        return nil
    }
    private func receiveEntityType(from type: Object.Type) -> Any.Type? {
        for useType in usedType where useType.realm == type {
            return useType.enity
        }
        return nil
    }

    // MARK: - Working with realm objects
    private func createNewRealmObject<T>(entity: T) -> Object? {
        if let entity = entity as? Manufacturer {
            return ManufacturerRealmObject(entity)
        } else if let entity = entity as? Tobacco {
            return TobaccoRealmObject(entity)
        } else if let entity = entity as? Taste {
            return TasteRealmObject(entity)
        } else if let entity = entity as? TobaccoLine {
            return TobaccoLineRealmObject(entity)
        } else {
            return nil
        }
    }
    private func updateRealmObject<T>(entity: T, object: Object) -> Object? {
        if let entity = entity as? Manufacturer,
           let object = object as? ManufacturerRealmObject,
           let newValuesDict = object.update(entity) {
            return ManufacturerRealmObject(value: newValuesDict)
        } else
        if let entity = entity as? Tobacco,
           let object = object as? TobaccoRealmObject,
           let newValuesDict = object.update(entity) {
            return TobaccoRealmObject(value: newValuesDict)
        } else
        if let entity = entity as? Taste,
           let object = object as? TasteRealmObject,
           let newValuesDict = object.update(entity) {
            return TasteRealmObject(value: newValuesDict)
        } else
        if let entity = entity as? TobaccoLine,
           let object = object as? TobaccoLineRealmObject,
           let newValuesDict = object.update(entity) {
            return TobaccoLineRealmObject(value: newValuesDict)
        } else {
            return nil
        }
    }
    private func defineRealmObject<T>(entity: T, object: Object) -> Bool {
        if let entity = entity as? Manufacturer,
           let object = object as? ManufacturerRealmObject {
            return entity.uid == object.uid
        } else
        if let entity = entity as? Tobacco,
           let object = object as? TobaccoRealmObject {
            return entity.uid == object.uid
        } else
        if let entity = entity as? Taste,
           let object = object as? TasteRealmObject {
            return entity.uid == object.uid
        } else
        if let entity = entity as? TobaccoLine,
           let object = object as? TobaccoLineRealmObject {
            return entity.uid == object.uid
        } else {
            return false
        }
    }
    private func receiveEntity<T>(from object: Object) -> T? {
        if let object = object as? ManufacturerRealmObject {
            return object.convertToEntity() as? T
        } else if let object = object as? TobaccoRealmObject {
            return object.convertToEntity() as? T
        } else if let object = object as? TasteRealmObject {
            return object.convertToEntity() as? T
        } else if let object = object as? TobaccoLineRealmObject {
            return object.convertToEntity() as? T
        } else {
            return nil
        }
    }

    // MARK: - Working with setting up links
    private func settingUpLinks<T: Sequence>(objects: [Object], entities: T) {
        switch T.Element.self {
        case is Manufacturer.Type:
            settingUpLinksBetweenManufacturerAndTobacco(objects: objects)
            settingUpLinksBetweenTobaccoLinesAndManufacturer(entities, realmObjects: objects)
        case is Tobacco.Type:
            settingUpLinksBetweenTobaccoAndTaste(entities, realmObjects: objects)
        case is TobaccoLine.Type:
            settingUpLinksBetweenTobaccoLinesAndTobacco(realmObjects: objects)
        default:
            break
        }
    }
    private func settingUpLinksBetweenManufacturerAndTobacco(objects: [Object]) {
        guard let manufacturers = objects as? [ManufacturerRealmObject] else { return }
        realmProvider.read(type: TobaccoRealmObject.self) { threadSafeObject in
            guard let wrapperdValue = threadSafeObject.wrappedValue else { return }
            manufacturers.forEach { manufacturer in
                let uid = manufacturer.uid
                let tobaccos = wrapperdValue.compactMap { object -> TobaccoRealmObject? in
                    guard let tobacco = object as? TobaccoRealmObject else { return nil }
                    return tobacco.uidManufacturer == uid ? tobacco : nil
                }
                manufacturer.tobaccos.removeAll()
                manufacturer.tobaccos.append(objectsIn: tobaccos)
            }
        }
    }
    private func settingUpLinksBetweenTobaccoAndTaste<T: Sequence>(_ objects: T, realmObjects: [Object]) {
        guard let tobaccos = objects as? [Tobacco],
              let realmObjects = realmObjects as? [TobaccoRealmObject] else { return }
        let dict = Dictionary(
            uniqueKeysWithValues: tobaccos.compactMap { tobacco -> (TobaccoRealmObject, Tobacco)? in
            guard let objectTobacco = realmObjects.first(where: { $0.uid == tobacco.uid }) else { return nil }
            return (objectTobacco, tobacco)
        })

        realmProvider.read(type: TasteRealmObject.self) { threadSafeObject in
            guard let wrapperdValue = threadSafeObject.wrappedValue else { return }
            dict.forEach { (object, tobacco) in
                let taste = wrapperdValue.compactMap { tasteObject -> TasteRealmObject? in
                    guard let taste = tasteObject as? TasteRealmObject else { return nil }
                    return tobacco.tastes.contains(where: { $0.uid == taste.uid }) ? taste : nil
                }
                object.taste.removeAll()
                object.taste.append(objectsIn: taste)
            }
        }
    }
    private func settingUpLinksBetweenTobaccoLinesAndManufacturer<T: Sequence>(_ objects: T, realmObjects: [Object]) {
        guard let manufacturers = objects as? [Manufacturer],
              let realmObjects = realmObjects as? [ManufacturerRealmObject] else { return }
        let filterManufacturers = manufacturers.filter { !$0.lines.isEmpty }
        let dict = Dictionary(uniqueKeysWithValues:
            filterManufacturers.compactMap({ manufacturer -> (ManufacturerRealmObject, Manufacturer)? in
            guard let ob = realmObjects.first(where: { $0.uid == manufacturer.uid }) else { return nil }
            return (ob, manufacturer)
        }))
        realmProvider.read(type: TobaccoLineRealmObject.self) { threadSafeObject in
            guard let wrapperdValue = threadSafeObject.wrappedValue else { return }
            dict.forEach { (object, manufacturer) in
                let tobaccoLines = wrapperdValue.compactMap { tobaccoLineObject -> TobaccoLineRealmObject? in
                    guard let tobaccoLineObject = tobaccoLineObject as? TobaccoLineRealmObject else { return nil }
                    return manufacturer.lines
                                .contains(where: { $0.uid == tobaccoLineObject.uid }) ? tobaccoLineObject : nil
                }
                object.lines.removeAll()
                object.lines.append(objectsIn: tobaccoLines)
            }
        }
    }
    private func settingUpLinksBetweenTobaccoLinesAndTobacco(realmObjects: [Object]) {
        guard let realmObjects = realmObjects as? [TobaccoLineRealmObject] else { return }
        realmProvider.read(type: TobaccoRealmObject.self) { threadSafeObject in
            guard let wrapperdValue = threadSafeObject.wrappedValue else { return }
            var dict: [String: [TobaccoRealmObject]] = [:]
            wrapperdValue.forEach { object in
                guard let tobacco = object as? TobaccoRealmObject else { return }
                let uid = tobacco.uidTobaccoLine
                if dict[uid] != nil {
                    dict[uid]?.append(tobacco)
                } else {
                    dict[uid] = [tobacco]
                }
            }
            realmObjects.forEach { object in
                if let array = dict[object.uid] {
                    object.tobaccos.removeAll()
                    object.tobaccos.append(objectsIn: array)
                }
            }
        }
    }
}

// MARK: - DataBaseServiceProtocol implementation
extension RealmDataBaseService: DataBaseServiceProtocol {
    func read<T>(type: T.Type,
                 completion: DataBaseObjectsHandler<[T]>?,
                 failure: DataBaseErrorHandler?) {
        guard let realmObjectType = receiveRealmType(from: type) else { failure?(.wrongTypeError); return }
        realmProvider.read(type: realmObjectType) { [weak self] threadSafeObject in
            guard let self = self else { return }
            guard let wrapperdValue = threadSafeObject.wrappedValue else { return }
            let entities = Array(wrapperdValue.compactMap { object -> T? in
                self.receiveEntity(from: object) })
            completion?(entities)
        }
    }

    func add<T>(entity: T,
                completion: DataBaseOperationCompletion?,
                failure: DataBaseErrorHandler?) {
        guard let newRealmObject = createNewRealmObject(entity: entity) else { failure?(.wrongTypeError); return }
        settingUpLinks(objects: [newRealmObject], entities: [entity])
        realmProvider.write(element: newRealmObject, completion: completion, failure: failure)
    }

    func add<T: Sequence>(entities: T,
                          completion: DataBaseOperationCompletion?,
                          failure: DataBaseErrorHandler?) {
        let newRealmObjects = entities.compactMap { object -> Object? in
            createNewRealmObject(entity: object)
        }
        settingUpLinks(objects: newRealmObjects, entities: entities)
        guard !newRealmObjects.isEmpty else { return }
        realmProvider.write(elements: newRealmObjects, completion: completion, failure: failure)
    }

    func update<T>(entity: T,
                   completion: DataBaseOperationCompletion?,
                   failure: DataBaseErrorHandler?) {
        guard let typeRealm = receiveRealmType(from: T.self) else { failure?(.wrongTypeError); return }
        realmProvider.read(type: typeRealm.self) { [weak self] threadSafeObject in
            guard let self = self else { return }
            guard let wrapperdValue = threadSafeObject.wrappedValue else { return }
            var newObject: Object
            if let object = wrapperdValue.first(where: { self.defineRealmObject(entity: entity, object: $0) }) {
                guard let updateObject = self.updateRealmObject(entity: entity, object: object) else { return }
                newObject = updateObject
            } else {
                guard let object = self.createNewRealmObject(entity: entity) else { return }
                newObject = object
            }
            self.settingUpLinks(objects: [newObject], entities: [entity])
            self.realmProvider.update(element: newObject, completion: completion, failure: failure)
        }
    }

    func update<T: Sequence>(entities: T,
                             completion: DataBaseOperationCompletion?,
                             failure: DataBaseErrorHandler?) {
        guard let typeRealm = receiveRealmType(from: T.Element.self) else { failure?(.wrongTypeError); return }
        realmProvider.read(type: typeRealm.self) { [weak self] threadSafeObject in
            guard let self = self else { return }
            guard let wrapperdValue = threadSafeObject.wrappedValue else { return }
            var updatedValues: [Object] = []
            var objectsForDeleted: Set<Object> = Set(wrapperdValue)
            entities.forEach { entity in
                if let object = wrapperdValue.first(where: { realmObject in
                    self.defineRealmObject(entity: entity, object: realmObject)
                }) {
                    objectsForDeleted.remove(object)
                    guard let updateObject = self.updateRealmObject(entity: entity, object: object) else { return }
                    updatedValues.append(updateObject)
                } else {
                    guard let newObject = self.createNewRealmObject(entity: entity) else { return }
                    updatedValues.append(newObject)
                }
            }
            if objectsForDeleted.count > 0 {
                self.realmProvider.delete(objects: objectsForDeleted, completion: nil, failure: failure)
            }
            self.settingUpLinks(objects: updatedValues, entities: entities)
            self.realmProvider.update(elements: updatedValues, completion: completion, failure: failure)
        }
    }
}
