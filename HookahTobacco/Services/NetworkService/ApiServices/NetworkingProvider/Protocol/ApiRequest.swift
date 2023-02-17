//
//  ApiRequest.swift
//  HookahTobacco
//
//  Created by антон кочетков on 16.02.2023.
//

import Foundation
import Alamofire

protocol ApiRequest: CustomStringConvertible {

    associatedtype ResponseSerializer: Alamofire.ResponseSerializer
    typealias Response = ResponseSerializer.SerializedObject

    var URL: URLConvertible { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var parametersEncoding: ParameterEncoding { get }
    var headers: [HTTPHeader]? { get }
    var baseURL: URLConvertible? { get }
    var responseSerializer: ResponseSerializer { get }
}

extension ApiRequest {
    var method: HTTPMethod {
        return .get
    }

    var parameters: [String: Any]? {
        return nil
    }

    var parametersEncoding: ParameterEncoding {
        JSONEncoding.default
    }

    var headers: [HTTPHeader]? {
        return nil
    }

    var baseURL: URLConvertible? {
        return GlobalConstant.apiURL
    }
}

extension ApiRequest {
    var description: String {
        return """
            Request: \(String(describing: type(of: self))),
               url: \(self.URL) (baseurl: \(String(describing: self.baseURL))),
               method: \(self.method),
               parameters: \(self.parameters ?? [:])),
               headers: \(String(describing: self.headers))
        """
    }
}
