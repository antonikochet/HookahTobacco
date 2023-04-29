//
//  GetTobaccosManufacturerRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation
import Alamofire

struct TobaccosManufacturerResponse: Decodable {
    let tobaccos: [Tobacco]
}

struct GetTobaccosManufacturerRequest: ApiRequest {
    private let idManufacurer: String
    
    init(idManufacurer: String) {
        self.idManufacurer = idManufacurer
    }
    
    var URL: URLConvertible {
        return "manufacturer/\(idManufacurer)/tobaccos"
    }
    
    var responseSerializer: DecodableResponseSerializer<TobaccosManufacturerResponse> {
        DecodableResponseSerializer<TobaccosManufacturerResponse>()
    }
}
