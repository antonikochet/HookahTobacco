//
//  FirestoreCollection.swift
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
    }
    
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
        }
        
        struct Tobacco {
            static let name = "name"
            static let taste = "taste"
            static let idManufacturer = "idManufacturer"
            static let nameManufacturer = "nameManufacturer"
            static let description = "description"
        }
    }
}
