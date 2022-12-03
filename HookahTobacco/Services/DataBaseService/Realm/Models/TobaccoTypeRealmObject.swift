//
//  TobaccoTypeRealmObject.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.12.2022.
//

import Foundation
import RealmSwift

enum TobaccoTypeRealmObject: Int, PersistableEnum {
    case none = -1
    case tobacco = 0
    case nonTobaccoBlend = 1

    mutating func update(_ tobaccoType: TobaccoType) {
        switch tobaccoType {
        case .tobacco:
            self = .tobacco
        case .nonTobaccoBlend:
            self = .nonTobaccoBlend
        }
    }
}

enum VarietyTobaccoLeafRealmObjects: Int, PersistableEnum {
    case none = -1
    case burley = 0
    case virginia = 1
    case oriental = 2

    mutating func update(_ tobaccoType: VarietyTobaccoLeaf) {
        switch tobaccoType {
        case .burley:
            self = .burley
        case .virginia:
            self = .virginia
        case .oriental:
            self = .oriental
        }
    }
}
