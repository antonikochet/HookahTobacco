//
//  TobaccoFilterRequestDTO.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

public typealias ArrayId = [Int]

public struct TobaccoFilterRequestDTO: Encodable {
    public let manufacturer: ArrayId?
    public let taste_type: ArrayId?
    public let tastes: ArrayId?
    public let tobacco_type: ArrayId?
    
    public init(
        manufacturer: ArrayId?,
        taste_type: ArrayId?,
        tastes: ArrayId?,
        tobacco_type: ArrayId?
    ) {
        self.manufacturer = manufacturer
        self.taste_type = taste_type
        self.tastes = tastes
        self.tobacco_type = tobacco_type
    }
}
