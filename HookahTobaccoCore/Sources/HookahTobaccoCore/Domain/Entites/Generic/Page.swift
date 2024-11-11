//
//  Page.swift
//
//
//  Created by Anton Kochetkov on 25.08.2023.
//

import HookahTobaccoNetwork

public struct Page<T> {
    public let count: Int
    public let next: Int?
    public let previous: Int?
    public let results: [T]
    
    public init(
        count: Int,
        next: Int?,
        previous: Int?,
        results: [T]
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
