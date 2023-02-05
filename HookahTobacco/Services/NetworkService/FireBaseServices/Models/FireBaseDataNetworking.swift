//
//  FireBaseDataNetworking.swift
//  HookahTobacco
//
//  Created by антон кочетков on 02.12.2022.
//

import Foundation

extension Manufacturer: DataNetworkingServiceProtocol {
    init?(_ data: [String: Any], uid: String) {
        self.uid = uid
        self.name = data[NamedFireStore.Documents.Manufacturer.name] as? String ?? ""
        self.country = data[NamedFireStore.Documents.Manufacturer.country] as? String ?? ""
        self.description = data[NamedFireStore.Documents.Manufacturer.description] as? String ?? ""
        self.nameImage = data[NamedFireStore.Documents.Manufacturer.image] as? String ?? ""
        self.link = data[NamedFireStore.Documents.Manufacturer.link] as? String ?? ""
        self.lines = data[NamedFireStore.Documents.Manufacturer.lines] as? [TobaccoLine] ?? []
    }

    func formatterToData() -> [String: Any] {
        return [
            NamedFireStore.Documents.Manufacturer.name: self.name,
            NamedFireStore.Documents.Manufacturer.country: self.country,
            NamedFireStore.Documents.Manufacturer.description: self.description,
            NamedFireStore.Documents.Manufacturer.image: self.nameImage,
            NamedFireStore.Documents.Manufacturer.link: self.link ?? "",
            NamedFireStore.Documents.Manufacturer.lines: self.lines.map { $0.uid }
        ]
    }
}

extension Tobacco: DataNetworkingServiceProtocol {
    init?(_ data: [String: Any], uid: String) {
        guard let name = data[NamedFireStore.Documents.Tobacco.name] as? String,
              let idManufacturer = data[NamedFireStore.Documents.Tobacco.idManufacturer] as? String,
              let nameManufacturer = data[NamedFireStore.Documents.Tobacco.nameManufacturer] as? String,
              let line = data[NamedFireStore.Documents.Tobacco.line] as? TobaccoLine
        else { return nil }
        self.uid = uid
        self.name = name
        self.tastes = data[NamedFireStore.Documents.Tobacco.taste] as? [Taste] ?? []
        self.idManufacturer = idManufacturer
        self.nameManufacturer = nameManufacturer
        self.description = data[NamedFireStore.Documents.Tobacco.description] as? String ?? ""
        self.line = line
        self.isFavorite = false
        self.isWantBuy = false
    }

    func formatterToData() -> [String: Any] {
        var dict = [String: Any]()
        dict[NamedFireStore.Documents.Tobacco.name] = name
        dict[NamedFireStore.Documents.Tobacco.idManufacturer] = idManufacturer
        dict[NamedFireStore.Documents.Tobacco.nameManufacturer] = nameManufacturer
        dict[NamedFireStore.Documents.Tobacco.taste] = tastes.map { $0.uid }
        dict[NamedFireStore.Documents.Tobacco.description] = description
        dict[NamedFireStore.Documents.Tobacco.line] = line.uid
        return dict
    }
}

extension Taste: DataNetworkingServiceProtocol {
    init?(_ data: [String: Any], uid: String) {
        guard let taste = data[NamedFireStore.Documents.Taste.taste] as? String,
              let typeTaste = data[NamedFireStore.Documents.Taste.type] as? String else { return nil }
        self.uid = uid
        self.taste = taste
        self.typeTaste = typeTaste
    }

    func formatterToData() -> [String: Any] {
        return [
            NamedFireStore.Documents.Taste.taste: self.taste,
            NamedFireStore.Documents.Taste.type: self.typeTaste
        ]
    }
}

extension TobaccoLine: DataNetworkingServiceProtocol {
    init?(_ data: [String: Any], uid: String) {
        guard let name = data[NamedFireStore.Documents.TobaccoLine.name] as? String,
              let packetingFormat = data[NamedFireStore.Documents.TobaccoLine.packetingFormat] as? [Int],
              let description = data[NamedFireStore.Documents.TobaccoLine.description] as? String,
              let isBase = data[NamedFireStore.Documents.TobaccoLine.isBaseLine] as? Bool else { return nil }
        self.uid = uid
        self.name = name
        self.packetingFormat = packetingFormat
        self.tobaccoType = TobaccoType(rawValue: data[NamedFireStore.Documents.TobaccoLine.tobaccoType] as? Int ?? 0)!
        self.tobaccoLeafType = (data[NamedFireStore.Documents.TobaccoLine.tobaccoLeafType] as? [Int])?
                                    .compactMap { VarietyTobaccoLeaf(rawValue: $0) }
        self.description = description
        self.isBase = isBase
    }

    func formatterToData() -> [String: Any] {
        var dict = [String: Any]()
        dict[NamedFireStore.Documents.TobaccoLine.name] = name
        dict[NamedFireStore.Documents.TobaccoLine.packetingFormat] = packetingFormat
        dict[NamedFireStore.Documents.TobaccoLine.tobaccoType] = tobaccoType.rawValue
        if let tobaccoLeafType = tobaccoLeafType {
            dict[NamedFireStore.Documents.TobaccoLine.tobaccoLeafType] = tobaccoLeafType.map { $0.rawValue }
        }
        dict[NamedFireStore.Documents.TobaccoLine.description] = description
        dict[NamedFireStore.Documents.TobaccoLine.isBaseLine] = isBase
        return dict
    }
}
