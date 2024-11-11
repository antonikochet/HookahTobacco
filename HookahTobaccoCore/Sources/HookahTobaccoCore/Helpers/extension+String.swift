//
//  File.swift
//  
//
//  Created by Антон Кочетков on 07.11.2024.
//

import Foundation

public extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else {
            return false
        }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
    func isEmailValid() -> Bool {
        self ~= "[[\\p{L}]+$0-9._%+-]+@[[\\p{L}]+$0-9.-]+\\.[[\\p{L}]+$]{2,64}"
    }
}
