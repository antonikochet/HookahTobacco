//
//  TasteChangeDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct TasteChangeDTO: Encodable {
    public let id: Int?
    public let taste: String
    public let typeTaste: [Int]
    
    public init(id: Int?, taste: String, typeTaste: [Int]) {
        self.id = id
        self.taste = taste
        self.typeTaste = typeTaste
    }
}
