//
//  GetTasteRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation
import Alamofire

struct GetTasteRequest: ApiRequest {
    var URL: URLConvertible {
        "taste/"
    }
    
    var responseSerializer: DecodableResponseSerializer<[Taste]> {
        DecodableResponseSerializer<[Taste]>()
    }
}
