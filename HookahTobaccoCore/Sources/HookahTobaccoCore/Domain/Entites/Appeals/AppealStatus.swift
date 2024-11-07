//
//  AppealStatus.swift
//
//
//  Created by Anton Kochetkov on 17.09.2023.
//

public enum AppealStatus: Int, CaseIterable {
    case notViewed = 0
    case processing
    case handled
    
    public init(dto: String) {
        switch dto {
        case "notViewed":
            self = .notViewed
        case "processing":
            self = .processing
        case "handled":
            self = .handled
        default:
            self = .notViewed
        }
    }
    
    public var stringRawValue: String {
        switch self {
        case .notViewed:
            "notViewed"
        case .processing:
            "processing"
        case .handled:
            "handled"
        }
    }
}
