//
//  TextFormatter.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation

public final class TextFormatter {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    public static func dateToString(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    public static func createDate(from string: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string) ?? Date.now
    }
    
    public static func createDate(from string: String, format: Format) -> Date {
        createDate(from: string, format: format.rawValue)
    }
    
    public enum Format: String {
        case fullServer = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }
}
