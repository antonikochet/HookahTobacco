//
//  HTRealm.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import Foundation
import RealmSwift

class HTRealm: HTRealmProtocol {
    // MARK: - HTRealmProtocol properties
    var workingQueue: DispatchQueue = DispatchQueue(label: "ru.HookahTobacco.realm.queue",
                                                     qos: .userInteractive)

    var fileName: String = "HTDabaBase.realm"

    var realmTypes: [Object.Type] = [
        ManufacturerRealmObject.self,
        TobaccoRealmObject.self,
        TasteRealmObject.self,
        TobaccoLineRealmObject.self
    ]

    var realmVersion: UInt64 {
        1
    }

    var migrationBlock: MigrationBlock?

    // MARK: - HTRealmProtocol initialization
    required init() { }
}
