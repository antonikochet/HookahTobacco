//
//  NetworkingProvider.swift
//  HookahTobacco
//
//  Created by антон кочетков on 17.02.2023.
//

import Foundation
import Alamofire

final class NetworkingProvider: NetworkingProviderProtocol {

    // MARK: - Private properties
    private var timeoutInterval: Double

    // MARK: - Init
    init(timeoutInterval: Double = 10.0) {
        self.timeoutInterval = timeoutInterval
    }

    // MARK: - NetworkingProviderProtocol
    func sendRequest<Request>(
        _ request: Request,
        completion: @escaping Completion<Request.Response>
    ) where Request: ApiRequest {

        guard let urlString = try? request.URL.asURL().absoluteString,
              let baseURL = try? request.baseURL?.asURL(),
              let url = URL(string: urlString, relativeTo: baseURL) else {
            return
        }
        let headers: HTTPHeaders = HTTPHeaders.default
        // TODO: add from request.header in headers

        AF.request(url,
                   method: request.method,
                   parameters: request.parameters,
                   encoding: request.parametersEncoding,
                   headers: headers) { [timeoutInterval] urlRequest in
            urlRequest.timeoutInterval = timeoutInterval
        }
                   .response(responseSerializer: request.responseSerializer) { result in
                       completion(result)
                   }
    }
}
