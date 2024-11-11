//
//  PageDTO.swift
//  
//
//  Created by Anton Kochetkov on 25.08.2023.
//

/// передавать в T тип получаемого результат без обертки массива
public struct PageDTO<T: Decodable>: Decodable {
    public let count: Int
    public let next: Int?
    public let previous: Int?
    public let results: [T]
}
