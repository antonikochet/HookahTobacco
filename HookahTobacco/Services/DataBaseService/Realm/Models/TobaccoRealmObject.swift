//
//  TobaccoRealmObject.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import RealmSwift

class TobaccoRealmObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var uid: String = ""
    @Persisted var name: String = ""
    @Persisted var descriptionTobacco: String = ""
    @Persisted var uidManufacturer: String = ""
    @Persisted(originProperty: "tobaccos") var manufacturer: LinkingObjects<ManufacturerRealmObject>
    @Persisted var taste: List<TasteRealmObject>
    // image

    var nameManufacturer: String? {
        manufacturer.first?.name
    }
}

extension TobaccoRealmObject {
    convenience init(_ tobacco: Tobacco) {
        self.init()
        self.uid = tobacco.uid
        self.name = tobacco.name
        self.descriptionTobacco = tobacco.description
        self.uidManufacturer = tobacco.idManufacturer
    }

    func update(_ tobacco: Tobacco) -> [String: Any]? {
        var newValues: [String: Any] = [:]
        newValues["id"] = self.id
        var isChange: Bool = false
        isChange = self.uid != tobacco.uid ? true : isChange
        newValues["uid"] = tobacco.uid
        isChange = self.name != tobacco.name ? true : isChange
        newValues["name"] = tobacco.name
        isChange = self.descriptionTobacco != tobacco.description ? true : isChange
        newValues["descriptionTobacco"] = tobacco.description
        isChange = self.uidManufacturer != tobacco.idManufacturer ? true : isChange
        newValues["uidManufacturer"] = tobacco.idManufacturer
        isChange = Set(self.taste.map { $0.convertToEntity() }) != Set(tobacco.tastes) ? true : isChange
        newValues["taste"] = [TasteRealmObject]()

        return isChange ? newValues : nil
    }

    func convertToEntity() -> Tobacco {
        Tobacco(id: self.id.stringValue,
                uid: self.uid,
                name: self.name,
                tastes: self.taste.map { $0.convertToEntity() },
                idManufacturer: self.uidManufacturer,
                nameManufacturer: self.nameManufacturer ?? "",
                description: self.descriptionTobacco,
                image: nil)
    }
}
