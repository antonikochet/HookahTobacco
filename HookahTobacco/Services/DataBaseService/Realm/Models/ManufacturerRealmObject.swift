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
    @Persisted var urlImage: String = ""
    @Persisted var link: String?
    @Persisted var tobaccos: List<TobaccoRealmObject>
    @Persisted var lines: List<TobaccoLineRealmObject>
}

extension ManufacturerRealmObject {
    convenience init(_ manufacturer: Manufacturer) {
        self.init()
        self.uid = manufacturer.uid
        self.name = manufacturer.name
        self.country = manufacturer.country.name
        self.descriptionManufacturer = manufacturer.description
        self.urlImage = manufacturer.urlImage
        self.link = manufacturer.link
    }

    func update(_ manufacturer: Manufacturer) -> [String: Any]? {
        var newValues: [String: Any] = [:]
        newValues["id"] = self.id
        newValues["uid"] = manufacturer.uid
        newValues["name"] = manufacturer.name
        newValues["country"] = manufacturer.country.name // TODO: - исправить это
        newValues["descriptionManufacturer"] = manufacturer.description
        newValues["urlImage"] = manufacturer.urlImage
        newValues["link"] = manufacturer.link
        newValues["tobaccos"] = [TobaccoRealmObject]()
        return newValues
    }

    func convertToEntity() -> Manufacturer {
        Manufacturer(
            id: id.stringValue,
            uid: uid,
            name: name,
            country: Country(name: country), // TODO: - исправить на получение объекта из бд
            description: descriptionManufacturer,
            urlImage: urlImage,
            image: nil,
            link: link,
            lines: Array(lines.map { $0.convertToEntity() })
        )
    }
}
