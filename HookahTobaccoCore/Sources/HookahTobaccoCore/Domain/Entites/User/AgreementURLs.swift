//
//  AgreementURLs.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public struct AgreementURLs {
    public let code: TypeAgreementURLs
    public let url: String
    
    init?(dto: AgreementURLsDTO) {
        guard let code = TypeAgreementURLs(rawValue: dto.code) else { return nil }
        self.code = code
        self.url = dto.url
    }
}

public enum TypeAgreementURLs: String, CaseIterable {
    case consentPersonalData = "PD"
    case userAgreement = "CL"
}
