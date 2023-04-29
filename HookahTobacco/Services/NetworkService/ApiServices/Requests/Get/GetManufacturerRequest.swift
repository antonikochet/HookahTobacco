//
//  GetManufacturerRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation
import Alamofire

struct GetManufacturerRequest: ApiRequest {
    var URL: URLConvertible {
        "manufacturer/"
    }
    
    var responseSerializer: DecodableResponseSerializer<[Manufacturer]> {
        DecodableResponseSerializer<[Manufacturer]>()
    }
}
