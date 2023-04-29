//
//  GetTobaccoLineRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation
import Alamofire

struct GetTobaccoLineRequest: ApiRequest {
    var URL: URLConvertible {
        "tobacco_line/"
    }
    
    var responseSerializer: DecodableResponseSerializer<[TobaccoLine]> {
        DecodableResponseSerializer<[TobaccoLine]>()
    }
}
