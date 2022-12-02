//
//  ManufacturerRealmObject.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import RealmSwift

class ManufacturerRealmObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var uid: String = ""
    @Persisted var name: String = ""
    @Persisted var country: String = ""
    @Persisted var descriptionManufacturer: String = ""
    @Persisted var nameImage: String = ""
    @Persisted var link: String?
    @Persisted var tobaccos: List<TobaccoRealmObject>
    @Persisted var lines: List<TobaccoLineRealmObject>
}

extension ManufacturerRealmObject {
    convenience init(_ manufacturer: Manufacturer) {
        self.init()
        self.uid = manufacturer.uid
        self.name = manufacturer.name
        self.country = manufacturer.country
        self.descriptionManufacturer = manufacturer.description
        self.nameImage = manufacturer.nameImage
        self.link = manufacturer.link
    }

    func update(_ manufacturer: Manufacturer) -> [String: Any]? {
        var newValues: [String: Any] = [:]
        newValues["id"] = self.id
        newValues["uid"] = manufacturer.uid
        newValues["name"] = manufacturer.name
        newValues["country"] = manufacturer.country
        newValues["descriptionManufacturer"] = manufacturer.description
        newValues["nameImage"] = manufacturer.nameImage
        newValues["link"] = manufacturer.link
        newValues["tobaccos"] = [TobaccoRealmObject]()
        return newValues
    }

    func convertToEntity() -> Manufacturer {
        Manufacturer(
            id: id.stringValue,
            uid: uid,
            name: name,
            country: country,
            description: descriptionManufacturer,
            nameImage: nameImage,
            image: nil,
            link: link,
            lines: Array(lines.map { $0.convertToEntity() })
        )
    }
}
