//
//  PageResponse.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 25.08.2023.
//

import Foundation

/// передавать в T тип получаемого результат без обертки массива
struct PageResponse<T: Decodable>: Decodable {
    let count: Int
    let next: Int?
    let previous: Int?
    let results: [T]
}
