//
//  NetworkingProviderProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.02.2023.
//

import Foundation
import Alamofire

protocol NetworkingProviderProtocol {
    typealias Completion<T> = (DataResponse<T, AFError>) -> Void

    func sendRequest<Request>(_ request: Request,
                              completion: @escaping Completion<Request.Response>
    ) where Request: ApiRequest
}
