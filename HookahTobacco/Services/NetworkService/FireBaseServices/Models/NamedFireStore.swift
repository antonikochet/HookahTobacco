//
//  NamedFireStore.swift
//  HookahTobacco
//
//  Created by антон кочетков on 19.09.2022.
//

import Foundation

struct NamedFireStore {
    struct Collections {
        static let users = "users"
        static let manufacturers = "manufacturers"
        static let `system` = "system"
        static let tobaccos = "tobaccos"
        static let tastes = "tastes"
        static let tobaccoLines = "tobaccoLines"
    }
    // swiftlint: disable nesting
    struct Documents {
        struct User {
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let isAdmin = "isAdmin"
        }

        struct Manufacturer {
            static let name = "name"
            static let country = "country"
            static let description = "description"
            static let image = "image"
            static let link = "link"
            static let lines = "lines"
        }

        struct Tobacco {
            static let name = "name"
            static let taste = "taste"
            static let idManufacturer = "idManufacturer"
            static let nameManufacturer = "nameManufacturer"
            static let description = "description"
            static let line = "line"
        }

        struct Taste {
            static let taste = "taste"
            static let type = "type"
        }

        struct TobaccoLine {
            static let name = "name"
            static let packetingFormat = "packetingFormat"
            static let tobaccoType = "tobaccoType"
            static let description = "description"
            static let isBaseLine = "isBaseLine"
        }

        struct System {
            static let versionDB = "versionDB"
        }
    }
    // swiftlint: enable nesting
}
