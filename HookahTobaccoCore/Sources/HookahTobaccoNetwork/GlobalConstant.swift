//
//  File.swift
//  
//
//  Created by Антон Кочетков on 07.11.2024.
//

import Foundation

struct GlobalConstant {
    static let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""
}
