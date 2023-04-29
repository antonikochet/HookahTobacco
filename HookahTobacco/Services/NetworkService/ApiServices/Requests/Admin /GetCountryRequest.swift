//
//  GetCountryRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation
import Alamofire

struct GetCountryRequest: ApiRequest {
    var URL: URLConvertible {
        "country/"
    }
    
    var responseSerializer: DecodableResponseSerializer<[Country]> {
        DecodableResponseSerializer<[Country]>()
    }
}
