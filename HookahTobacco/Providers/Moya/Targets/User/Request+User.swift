//
//  Request+User.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 23.08.2023.
//

import Foundation

struct UpdateTobaccosUser: Encodable {
    let id: Int
    let flag: Bool
}

struct AgreementURLsRequest: Encodable {
    let urls: [TypeAgreementURLs]
}

enum TypeAgreementURLs: String, CaseIterable, Codable {
    case consentPersonalData = "PD"
    case userAgreement = "CL"
}
