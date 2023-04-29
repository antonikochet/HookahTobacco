//
//  GetTasteTypeRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation
import Alamofire

struct GetTasteTypeRequest: ApiRequest {
    var URL: URLConvertible {
        "taste_type/"
    }
    
    var responseSerializer: DecodableResponseSerializer<[TasteType]> {
        DecodableResponseSerializer<[TasteType]>()
    }
}
