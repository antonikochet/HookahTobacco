//
//  Gender.swift
//  
//
//  Created by Anton Kochetkov on 11.08.2023.
//

public enum Gender: Int {
    case notPicked
    case male
    case female
    
    internal init(rawValue: Int?) {
        switch rawValue {
        case 1:
            self = .male
        case 2:
            self = .female
        default:
            self = .notPicked
        }
    }
}
