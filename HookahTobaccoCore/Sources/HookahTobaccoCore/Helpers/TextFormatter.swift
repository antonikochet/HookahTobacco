//
//  File.swift
//  
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation

final class TextFormatter {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static func dateToString(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func createDate(from string: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string) ?? Date.now
    }
}
