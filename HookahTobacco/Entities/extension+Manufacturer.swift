//
//  extension+Manufacturer.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation
import HookahTobaccoCore

extension Manufacturer: Equatable {
    public static func == (lmnf: Manufacturer, rmnf: Manufacturer) -> Bool {
        lmnf.name == rmnf.name
    }
}
