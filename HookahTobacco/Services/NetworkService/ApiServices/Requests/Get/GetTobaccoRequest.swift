//
//  GetTobaccoRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation
import Alamofire

struct GetTobaccoRequest: ApiRequest {
    var URL: URLConvertible {
        "tobacco/"
    }
    
    var responseSerializer: DecodableResponseSerializer<[Tobacco]> {
        DecodableResponseSerializer<[Tobacco]>()
    }
}
