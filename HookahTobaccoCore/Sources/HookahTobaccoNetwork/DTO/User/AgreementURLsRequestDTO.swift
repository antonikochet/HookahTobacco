//
//  AgreementURLsRequestDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation

public struct AgreementURLsRequestDTO: Encodable {
    public let urls: [String]
    
    public init(urls: [String]) {
        self.urls = urls
    }
}
