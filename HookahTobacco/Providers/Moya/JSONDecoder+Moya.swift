//
//  JSONDecoder+Moya.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//

import Foundation

enum DateError: String, Error {
    case invalidDate
}

extension JSONDecoder {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            do {
                let dateStr = try container.decode(String.self)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                if let date = formatter.date(from: dateStr) {
                    return date
                }
            } catch {
                let strError = error
                do {
                    let dateInt = try container.decode(Int.self)
                    return Date(timeIntervalSince1970: TimeInterval(dateInt / 1000))
                } catch {
                    throw strError
                }
            }
            throw DateError.invalidDate
        })
        return decoder
    }
}
