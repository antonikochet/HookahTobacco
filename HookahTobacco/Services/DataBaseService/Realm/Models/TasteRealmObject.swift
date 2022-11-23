//
//  TasteRealmObject.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import RealmSwift

class TasteRealmObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var uid: Int = -1
    @Persisted var taste: String = ""
    @Persisted var type: String = ""
//    @Persisted(originProperty: "taste") var tobaccos: LinkingObjects<TobaccoRealmObject>
}

extension TasteRealmObject {
    convenience init(_ taste: Taste) {
        self.init()
        self.uid = taste.uid
        self.taste = taste.taste
        self.type = taste.typeTaste
    }

    func update(_ taste: Taste) -> [String: Any]? {
        var newValues: [String: Any] = [:]
        newValues["id"] = self.id
        var isChange: Bool = false
        isChange = self.uid != taste.uid ? true : isChange
        newValues["uid"] = taste.uid
        isChange = self.taste != taste.taste ? true : isChange
        newValues["taste"] = taste.taste
        isChange = self.type != taste.typeTaste ? true : isChange
        newValues["type"] = taste.typeTaste

        return isChange ? newValues : nil
    }

    func convertToEntity() -> Taste {
        Taste(id: self.id.stringValue,
              uid: self.uid,
              taste: self.taste,
              typeTaste: self.type)
    }
}
