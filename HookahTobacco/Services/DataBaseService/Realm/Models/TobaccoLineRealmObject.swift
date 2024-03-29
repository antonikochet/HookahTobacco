//
//  TobaccoLineRealmObject.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.11.2022.
//

import RealmSwift
import Realm

class TobaccoLineRealmObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var uid: Int = -1
    @Persisted var name: String = ""
    @Persisted var packetingFormat: MutableSet<Int>
    @Persisted var tobaccoType: TobaccoTypeRealmObject = .none
    @Persisted var tobaccoLeafType: MutableSet<VarietyTobaccoLeafRealmObjects>
    @Persisted var descriptionTL: String = ""
    @Persisted var isBaseLine: Bool = false
    @Persisted var tobaccos: List<TobaccoRealmObject>
}

extension TobaccoLineRealmObject {
    convenience init(_ tobaccoLine: TobaccoLine) {
        self.init()
        self.uid = tobaccoLine.uid
        self.name = tobaccoLine.name
        self.packetingFormat.insert(objectsIn: tobaccoLine.packetingFormat)
        self.tobaccoType.update(tobaccoLine.tobaccoType)
        self.tobaccoLeafType.insert(objectsIn:
                                        tobaccoLine.tobaccoLeafType?
                                        .compactMap { VarietyTobaccoLeafRealmObjects(rawValue: $0.rawValue) } ?? [])
        self.descriptionTL = tobaccoLine.description
        self.isBaseLine = tobaccoLine.isBase
    }

    func update(_ tobaccoLine: TobaccoLine) -> [String: Any]? {
        var newValues: [String: Any] = [:]
        newValues["id"] = self.id
        newValues["uid"] = tobaccoLine.uid
        newValues["name"] = tobaccoLine.name
        newValues["packetingFormat"] = tobaccoLine.packetingFormat
        newValues["tobaccoType"] = tobaccoLine.tobaccoType.rawValue
        newValues["descriptionTL"] = tobaccoLine.description
        newValues["isBaseLine"] = tobaccoLine.isBase
        newValues["tobaccoLeafType"] = tobaccoLine.tobaccoLeafType?.map { $0.rawValue } ?? []
        return newValues
    }

    func convertToEntity() -> TobaccoLine {
        TobaccoLine(id: self.id.stringValue,
                    uid: self.uid,
                    name: self.name,
                    packetingFormat: self.packetingFormat.map { $0 },
                    tobaccoType: TobaccoType(rawValue: self.tobaccoType.rawValue)!,
                    tobaccoLeafType: self.tobaccoLeafType.compactMap { VarietyTobaccoLeaf(rawValue: $0.rawValue) },
                    description: self.descriptionTL,
                    isBase: self.isBaseLine)
    }
}
