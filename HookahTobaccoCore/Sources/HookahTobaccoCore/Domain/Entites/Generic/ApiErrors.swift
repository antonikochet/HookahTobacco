//
//  ApiErrors.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import HookahTobaccoNetwork

// TODO: - выписать все коды ошибок от бека и поменять в ApiError.code
//enum ApiCodeError {
//    case detail
//}

public struct ApiError {
    public let code: String
    public let message: String
    public let fieldName: String?
    
    internal init(dto: ApiErrorDTO) {
        self.code = dto.error
        self.message = dto.message
        self.fieldName = dto.field_name
    }
}
