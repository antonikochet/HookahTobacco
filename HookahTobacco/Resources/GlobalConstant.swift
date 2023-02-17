//
//  GlobalConstant.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation

struct GlobalConstant {
    static let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""
}
