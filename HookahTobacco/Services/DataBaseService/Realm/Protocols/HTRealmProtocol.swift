//
//  HTRealmProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import Foundation
import RealmSwift

protocol HTRealmProtocol {
    init()

    var workingQueue: DispatchQueue { get }
    var fileName: String { get }
    var realmTypes: [Object.Type] { get }

    var realmVersion: UInt64 { get }
    var migrationBlock: MigrationBlock? { get }
}
