//
//  LoginEntity.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

import HookahTobaccoNetwork

public struct LoginEntity {
    public let token: String
    
    init(dto: LoginDTO) {
        self.token = dto.token
    }
}

